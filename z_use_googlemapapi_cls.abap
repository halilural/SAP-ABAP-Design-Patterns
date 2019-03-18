CLASS lcl_singleton DEFINITION CREATE PRIVATE .

  PUBLIC SECTION.

    CLASS-METHODS get_instance RETURNING VALUE(re_value) TYPE REF TO lcl_singleton.

*    I am managing global variables into singleton class .

    DATA :  gv_http_client TYPE REF TO if_http_client,
            gv_content     TYPE string,
            gt_dest        TYPE tt_dest.

  PRIVATE SECTION.
    CLASS-DATA instance TYPE REF TO lcl_singleton.

ENDCLASS.

CLASS lcl_singleton IMPLEMENTATION.

  METHOD get_instance.

    IF instance IS NOT BOUND.

      instance = NEW lcl_singleton( ).

    ENDIF.

    re_value = instance.

  ENDMETHOD.

ENDCLASS.
