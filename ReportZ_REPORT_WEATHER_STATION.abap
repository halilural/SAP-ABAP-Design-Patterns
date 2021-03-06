REPORT z_report_weather_station.


CLASS lcl_weatherstation DEFINITION DEFERRED .
CLASS lcl_receiver DEFINITION DEFERRED.


* DATA DECLARATIONS

TYPES : tt_data TYPE STANDARD TABLE OF zae_s_weather_cond WITH EMPTY KEY.

DATA : gv_dec      TYPE p LENGTH 6 DECIMALS 3.

DATA : gr_receiver TYPE REF TO lcl_receiver,
       gr_timer    TYPE REF TO cl_gui_timer,
       i_data      TYPE tt_data,
       gr_grid     TYPE REF TO cl_gui_alv_grid,
       gt_fc       TYPE lvc_t_fcat.

CONSTANTS:
c_interval TYPE i VALUE 3.

INCLUDE z_report_weather_station_cls.

DATA lr_weatherdata TYPE REF TO lcl_weatherdata.

* Observings one will be subscribed to Subject .
* It will regularly taking temperature , humidity and pressure datas from Subject.
* Kind of Publisher & Subscriber Arrangement .

DATA lr_currentcond       TYPE REF TO lif_observer .
DATA lr_statisticsdisplay TYPE REF TO lif_observer.
DATA lr_forecastdisplay   TYPE REF TO lif_observer.
DATA lr_thirdpartydisplay TYPE REF TO lif_observer.
DATA lr_heatindexdisplay  TYPE REF TO lif_observer.


**********************************************************************
* Starting timer for getting values from the weather data class

INITIALIZATION.

  IF gr_receiver IS NOT BOUND.

    gr_receiver =  NEW lcl_receiver( ).

  ENDIF.

  IF gr_timer IS NOT BOUND.

    gr_timer = NEW cl_gui_timer( ).

  ENDIF.

START-OF-SELECTION.

**********************************************************************

  i_data = VALUE #( ( temp = lcl_weatherstation=>cl_temperature
                      humi = lcl_weatherstation=>cl_humidity
                      press = lcl_weatherstation=>cl_pressure ) ) .

**********************************************************************

  lcl_weatherstation=>starttimer( ).

  WRITE 'Wait for timer messages...'.

*  * subject class is creating .



  IF lr_weatherdata IS NOT BOUND.

    lr_weatherdata = NEW lcl_weatherdata( ).

  ENDIF.



  IF lr_currentcond IS NOT BOUND.

    lr_currentcond = NEW lcl_currentconditionsdisplay( im_subject = lr_weatherdata ) .

  ENDIF.

  IF lr_statisticsdisplay IS NOT BOUND.

    lr_statisticsdisplay = NEW lcl_statisticsdisplay( im_subject = lr_weatherdata ) .

  ENDIF.

  IF lr_forecastdisplay IS NOT BOUND.

    lr_forecastdisplay = NEW lcl_forecastdisplay( im_subject = lr_weatherdata ).

  ENDIF.

  IF lr_thirdpartydisplay IS NOT BOUND.

    lr_thirdpartydisplay = NEW lcl_thirdparty( im_subject = lr_weatherdata  ).

  ENDIF.

  IF lr_heatindexdisplay IS NOT BOUND.

    lr_heatindexdisplay = NEW lcl_heatindexdisplay( im_subject = lr_weatherdata ) .

  ENDIF.

* subject is grabbing data from the weather station


  gr_timer->run(
    EXCEPTIONS
      error  = 1
      OTHERS = 2
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

**********************************************************************

*  PERFORM refresh_view.

**********************************************************************
END-OF-SELECTION.

**********************************************************************
FORM refresh_view .

* It is just simulation generating data .

* All data are grabbing from The Weather being Static Class

  lcl_weatherstation=>generatorvalues( ).

* So , setting manufacturing data within Subject .

  lr_weatherdata->setmeasurements(
  EXPORTING
    im_temp = lcl_weatherstation=>cl_temperature
    im_humi = lcl_weatherstation=>cl_humidity
    im_pres = lcl_weatherstation=>cl_pressure
).

  DATA lv_index TYPE sy-linno.

  lv_index = sy-linno.

  SCROLL LIST FORWARD .

ENDFORM.
