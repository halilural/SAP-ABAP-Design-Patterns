REPORT z_use_googlemapapi_and_shw_mp NO STANDARD PAGE HEADING.

INCLUDE z_use_googlemapapi_top.
INCLUDE z_use_googlemapapi_cls.
INCLUDE z_use_googlemapapi_hlpr_cls.

SELECTION-SCREEN BEGIN OF BLOCK b1 .

PARAMETERS p_add_f TYPE c LENGTH 50.

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.


START-OF-SELECTION.

* Creation of new HTTP Client Object

  DATA(instance) = lcl_singleton=>get_instance( ).

  lcl_report_class=>lif_report~create_http_client(
    EXPORTING
      im_pr_address = p_add_f
    CHANGING
      c_http_client = instance->gv_http_client
  ).

*  Request and Calling Get Method

  lcl_report_class=>lif_report~http_client_request_get_method( im_http_client = instance->gv_http_client ).

* Send the request

  lcl_report_class=>lif_report~http_client_send( im_http_client = instance->gv_http_client ).

* Retrieve the result

  lcl_report_class=>lif_report~http_client_receive(
    EXPORTING
      im_http_client = instance->gv_http_client
    CHANGING
      c_content      = instance->gv_content
  ).

* Get the actual coordinate using the content string

  lcl_report_class=>lif_report~get_coordinates(
    EXPORTING
      im_content    = instance->gv_content
      im_pr_address = p_add_f
    CHANGING
      ct_dest       = instance->gt_dest
  ).

  lcl_report_class=>lif_report~display_lat_longtitude( im_test = instance->gt_dest  ).
