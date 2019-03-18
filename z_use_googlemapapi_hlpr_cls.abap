INTERFACE lif_report.

  CLASS-METHODS : create_http_client IMPORTING VALUE(im_pr_address) TYPE c
                                     CHANGING  VALUE(c_http_client) TYPE REF TO if_http_client,
    http_client_request_get_method IMPORTING VALUE(im_http_client) TYPE REF TO if_http_client,
    http_client_send IMPORTING VALUE(im_http_client) TYPE REF TO if_http_client,
    http_client_receive IMPORTING VALUE(im_http_client) TYPE REF TO if_http_client
                        CHANGING  VALUE(c_content)      TYPE string ,
    get_coordinates     IMPORTING VALUE(im_content) TYPE string
                                  im_pr_address     TYPE c
                        CHANGING  VALUE(ct_dest)    TYPE tt_dest,
    display_lat_longtitude IMPORTING VALUE(im_test) TYPE tt_dest.

ENDINTERFACE.

* Final means sealed class , so No one class can't derive from it.

CLASS lcl_report_class DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_report.

ENDCLASS.

CLASS lcl_report_class IMPLEMENTATION.

  METHOD lif_report~create_http_client.

    DATA lv_http_url TYPE string.

* Prepare the url of the address

    lv_http_url = |{ 'http://maps.google.com/maps/api/geocode/xml?address=' }{ im_pr_address }|.

* Get client from url

    CALL METHOD cl_http_client=>create_by_url
      EXPORTING
        url                = lv_http_url    " URL
      IMPORTING
        client             = c_http_client     " HTTP Client Abstraction
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD lif_report~http_client_request_get_method.

*  Request and Get

    im_http_client->request->set_header_field(
      EXPORTING
        name  = '~request_method'    " Name of the header field
        value = 'GET'    " HTTP header field value
    ).

  ENDMETHOD.

  METHOD lif_report~http_client_send.

* Send the request

    im_http_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD lif_report~http_client_receive.

*  Retrieve the result

    CALL METHOD im_http_client->receive
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    c_content = im_http_client->response->get_cdata( ).

  ENDMETHOD.

  METHOD lif_report~get_coordinates.

** Local data declaration
    DATA: lv_url  TYPE c LENGTH 255,
          ls_dest TYPE ty_dest,
          moff    TYPE syst-tabix,
          moff1   TYPE syst-tabix,
          lv_len  TYPE syst-tabix,
          lv_lat  TYPE c LENGTH 20,
          lv_lng  TYPE c LENGTH 20.

*&---------------------------------------------------------------------*
*& Processing string
*&---------------------------------------------------------------------*
    DO .
* Find <location> text in the content string
      FIND '<location>' IN SECTION OFFSET moff OF im_content IGNORING CASE MATCH OFFSET moff .

      IF sy-subrc = 0 .
* <location> is a 10 character string, hence adding 10
        moff = moff + 10 .

* Find closing tag </location> text in the content string
        FIND '</location>' IN SECTION OFFSET moff OF im_content IGNORING CASE MATCH OFFSET moff1 .

* Find the length of string between tag <location> and </location>
        lv_len = moff1 - moff .

* We have seen the API string contet, so we know <lat> </lat> <lng> </lng> are there between
* <location> and </location>
*--------------------------------------------------------------------*
* ---------------Find latitude
*--------------------------------------------------------------------*
* Find string <lat>
        FIND '<lat>' IN SECTION OFFSET moff OF im_content IGNORING CASE MATCH OFFSET moff .
        IF sy-subrc = 0 .
* <lat> is a 5 character string, hence adding 5
          moff = moff + 5 .

* Find closing tag </lat> text in the content string
          FIND '</lat>' IN SECTION OFFSET moff OF im_content IGNORING CASE MATCH OFFSET moff1 .

* Find the length of string between tag <lat> and </lat>
          lv_len = moff1 - moff .

* Characters between <lat> </lat> will have the latitude coorniate
          lv_lat = im_content+moff(lv_len) .

* From place address
          ls_dest-place_f = im_pr_address .

* Keep latitude in structure
          ls_dest-lat_f = lv_lat.

        ENDIF.

*--------------------------------------------------------------------*
* ---------------Find longitude
*--------------------------------------------------------------------*
* Find string <lng>
        FIND '<lng>' IN SECTION OFFSET moff OF im_content IGNORING CASE MATCH OFFSET moff .
        IF sy-subrc = 0 .

* <lng> is a 5 character string, hence adding 5
          moff = moff + 5 .

* Find closing tag </lng> text in the content string
          FIND '</lng>' IN SECTION OFFSET moff OF im_content IGNORING CASE MATCH OFFSET moff1 .

* Find the length of string between tag <lng> and </lng>
          lv_len = moff1 - moff .

* Characters between <lng> </lng> will have the latitude coorniate
          lv_lng = im_content+moff(lv_len) .

* Keep longitude in structure
          ls_dest-lng_f = lv_lng.

        ENDIF.
      ELSE.

        EXIT.

      ENDIF.

    ENDDO .

* Put in internal table to display later
    APPEND ls_dest TO ct_dest.
    CLEAR:ls_dest .

  ENDMETHOD.

  METHOD lif_report~display_lat_longtitude.

    DATA:
      lr_alv       TYPE REF TO cl_salv_table,
      lr_columns   TYPE REF TO cl_salv_columns_table,
      lr_column    TYPE REF TO cl_salv_column,
      lr_functions TYPE REF TO cl_salv_functions_list,
      lr_display   TYPE REF TO cl_salv_display_settings,
      lr_layout    TYPE REF TO cl_salv_layout,
      ls_key       TYPE salv_s_layout_key,
      lr_sorts     TYPE REF TO cl_salv_sorts.

    " Check to make sure the internal table has data.
    IF lines( im_test ) > 0.

      TRY.
*       Create ALV instance
*       Use CALL METHOD since this is a static method
          CALL METHOD cl_salv_table=>factory
            IMPORTING
              r_salv_table = lr_alv
            CHANGING
              t_table      = im_test.

*       Get functions object and then set all the functions to be allowed
          lr_functions = lr_alv->get_functions( ).
          lr_functions->set_all( ).

          lr_columns = lr_alv->get_columns( ).

          CALL METHOD lr_columns->get_column
            EXPORTING
              columnname = 'PLACE_F'
            RECEIVING
              value      = lr_column.
          CALL METHOD lr_column->set_short_text
            EXPORTING
              value = ''.
          CALL METHOD lr_column->set_medium_text
            EXPORTING
              value = ''.
          CALL METHOD lr_column->set_long_text
            EXPORTING
              value = 'Place Name'.

          CALL METHOD lr_columns->get_column
            EXPORTING
              columnname = 'LAT_F'
            RECEIVING
              value      = lr_column.
          CALL METHOD lr_column->set_short_text
            EXPORTING
              value = ''.
          CALL METHOD lr_column->set_medium_text
            EXPORTING
              value = ''.
          CALL METHOD lr_column->set_long_text
            EXPORTING
              value = 'Latitude'.

          CALL METHOD lr_columns->get_column
            EXPORTING
              columnname = 'LNG_F'
            RECEIVING
              value      = lr_column.
          CALL METHOD lr_column->set_short_text
            EXPORTING
              value = ''.
          CALL METHOD lr_column->set_medium_text
            EXPORTING
              value = ''.
          CALL METHOD lr_column->set_long_text
            EXPORTING
              value = 'Longitude'.


          lr_columns->set_optimize( ).

*       Set sort column
          lr_sorts = lr_alv->get_sorts( ).
          lr_sorts->clear( ).

*       This code is to get the layout, save the layout and display the layout
          lr_layout = lr_alv->get_layout( ).
          ls_key-report = sy-repid.
          lr_layout->set_key( ls_key ).
          lr_layout->set_default( ' ' ).
          lr_layout->set_save_restriction( cl_salv_layout=>restrict_none ).


          lr_display = lr_alv->get_display_settings( ).
          lr_display->set_striped_pattern( cl_salv_display_settings=>true ).

*       Now display the report as an ALV grid
          lr_alv->display( ).

        CATCH cx_salv_msg.
          WRITE: 'Error displaying grid CX_SALV_MSG!'(001).

        CATCH cx_salv_not_found.
          WRITE: 'Error displaying grid CX_SALV_NOT_FOUND!'(002).

        CATCH cx_salv_data_error.
          WRITE: 'Error displaying grid CX_SALV_DATA_ERROR!'(003).

        CATCH cx_salv_existing.
          WRITE: 'Error displaying grid CX_SALV_EXISTING!'(004).

      ENDTRY.

    ELSE.
      MESSAGE 'No data to display' TYPE 'I'.
      LEAVE LIST-PROCESSING.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
