**********************************************************************
**********************DEFINE TIMER FOR SUB-PROCESS********************

CLASS lcl_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS : handle_finished FOR EVENT finished OF cl_gui_timer .

ENDCLASS.

CLASS lcl_receiver IMPLEMENTATION.

  METHOD handle_finished.

    PERFORM refresh_view .

    CALL METHOD gr_timer->run
      EXCEPTIONS
        error  = 1
        OTHERS = 2.

    IF sy-subrc <> 0.

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

**********************************************************************
*   Taking a first,  we need to give some values from the weather station
*   So that , we add a class that make this task .
**********************************************************************
CLASS lcl_weatherstation DEFINITION .

  PUBLIC SECTION.

    CLASS-DATA cl_temperature LIKE gv_dec.
    CLASS-DATA cl_humidity    LIKE gv_dec.
    CLASS-DATA cl_pressure    LIKE gv_dec.
    CLASS-DATA cl_status      TYPE abap_bool VALUE abap_false.

    CLASS-METHODS :
      class_constructor ,
      gettemperature RETURNING VALUE(re_value) LIKE cl_temperature,
      gethumidity RETURNING VALUE(re_value) LIKE cl_humidity,
      getpressure RETURNING VALUE(re_value) LIKE cl_pressure,
      settemperature IMPORTING VALUE(im_value) LIKE cl_temperature,
      sethumidity IMPORTING VALUE(im_value) LIKE cl_humidity,
      setpressure IMPORTING VALUE(im_value) LIKE cl_pressure,
      generatorvalues,
      starttimer .

  PRIVATE SECTION.

*** The weather station class ' s data .

ENDCLASS.

CLASS lcl_weatherstation IMPLEMENTATION.

  METHOD class_constructor.

    CLEAR : lcl_weatherstation=>cl_humidity ,
            lcl_weatherstation=>cl_pressure ,
            lcl_weatherstation=>cl_temperature.

    lcl_weatherstation=>starttimer( ).

  ENDMETHOD.

  METHOD gettemperature.

    re_value = lcl_weatherstation=>cl_temperature.

  ENDMETHOD.

  METHOD gethumidity.

    re_value = lcl_weatherstation=>cl_humidity.

  ENDMETHOD.

  METHOD getpressure.

    re_value = lcl_weatherstation=>cl_pressure.

  ENDMETHOD.

  METHOD settemperature.

    lcl_weatherstation=>cl_temperature = im_value.

  ENDMETHOD.

  METHOD sethumidity.

    lcl_weatherstation=>cl_humidity = im_value.

  ENDMETHOD.

  METHOD setpressure.

    lcl_weatherstation=>cl_pressure = im_value.

  ENDMETHOD.

  METHOD starttimer.

**********************************************************************
*******Start timer for grabing data's from somewhere .

    SET HANDLER gr_receiver->handle_finished FOR gr_timer .

    gr_timer->interval = c_interval.

    CALL METHOD gr_timer->run
      EXCEPTIONS
        error  = 1
        OTHERS = 2.

    IF sy-subrc <> 0.

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD generatorvalues.

    DATA lv_value TYPE wrbtr_bi .

    CLEAR : lcl_weatherstation=>cl_humidity ,
        lcl_weatherstation=>cl_pressure ,
        lcl_weatherstation=>cl_temperature.

    CLEAR lv_value.

    CALL FUNCTION 'RANDOM_AMOUNT'
      EXPORTING
        rnd_min    = '10'
        rnd_max    = '100'
        valcurr    = 'DEM'
      IMPORTING
        rnd_amount = lv_value.

    CONDENSE lv_value NO-GAPS.

    REPLACE ALL OCCURRENCES OF ',' IN lv_value WITH '.'.

    lcl_weatherstation=>sethumidity( im_value = CONV #( lv_value ) ).

    CLEAR lv_value.

    CALL FUNCTION 'RANDOM_AMOUNT'
      EXPORTING
        rnd_min    = '10'
        rnd_max    = '100'
        valcurr    = 'DEM'
      IMPORTING
        rnd_amount = lv_value.

    CONDENSE lv_value NO-GAPS.

    REPLACE ALL OCCURRENCES OF ',' IN lv_value WITH '.'.

    lcl_weatherstation=>setpressure( im_value = CONV #( lv_value ) ).

    CLEAR lv_value.

    CALL FUNCTION 'RANDOM_AMOUNT'
      EXPORTING
        rnd_min    = '10'
        rnd_max    = '100'
        valcurr    = 'DEM'
      IMPORTING
        rnd_amount = lv_value.

    CONDENSE lv_value NO-GAPS.

    REPLACE ALL OCCURRENCES OF ',' IN lv_value WITH '.'.

    lcl_weatherstation=>settemperature( im_value = CONV #( lv_value ) ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************
*******************INTERFACES FOR SUBJECT AND OBSERVERS***************
**********************************************************************

INTERFACE lif_observer.

  METHODS update IMPORTING VALUE(im_temp) LIKE gv_dec
                           VALUE(im_humi) LIKE gv_dec
                           VALUE(im_pres) LIKE gv_dec.

ENDINTERFACE.

**********************************************************************

INTERFACE lif_displayelement.

  METHODS : display .

ENDINTERFACE.

**********************************************************************

INTERFACE lif_subject.

  METHODS :
    registerobserver IMPORTING VALUE(im_observer) TYPE REF TO lif_observer,
    removeobserver IMPORTING VALUE(im_observer) TYPE REF TO lif_observer,
    notifyobserver .

ENDINTERFACE.

**********************************************************************
*****************IMPLEMENTATION ABOVE INTERFACES**********************
**********************************************************************

CLASS lcl_currentconditionsdisplay DEFINITION .
  PUBLIC SECTION.

    INTERFACES : lif_observer,
      lif_displayelement.

    METHODS : constructor IMPORTING VALUE(im_subject) TYPE REF TO lif_subject.

  PRIVATE SECTION.

    DATA : temperature LIKE gv_dec,
           humidity    LIKE gv_dec,
           subject     TYPE REF TO lif_subject.

ENDCLASS.

CLASS lcl_currentconditionsdisplay IMPLEMENTATION.

  METHOD constructor.

    subject = im_subject.
    subject->registerobserver( im_observer = me ).

  ENDMETHOD.

  METHOD lif_observer~update.

    me->temperature = im_temp.
    me->humidity = im_humi.

    me->lif_displayelement~display( ).

  ENDMETHOD.

  METHOD lif_displayelement~display.

    WRITE : / 'Current Conditions: ' && me->temperature
              && 'F degrees and ' && me->humidity && '% humidity'.

    ULINE.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_statisticsdisplay DEFINITION .
  PUBLIC SECTION.

    INTERFACES : lif_observer,
      lif_displayelement.

    METHODS : constructor IMPORTING VALUE(im_subject) TYPE REF TO lif_subject.

  PRIVATE SECTION.

    DATA :  min_temp     LIKE gv_dec VALUE 100,
            min_hum      LIKE gv_dec VALUE 100,
            min_pres     LIKE gv_dec VALUE 100,
            max_temp     LIKE gv_dec,
            max_hum      LIKE gv_dec,
            max_pres     LIKE gv_dec,
            avg_temp     LIKE gv_dec,
            avg_hum      LIKE gv_dec,
            avg_pres     LIKE gv_dec,
            subject      TYPE REF TO lif_subject,
            mt_stat_data TYPE tt_data.
    METHODS calculate_value
      IMPORTING
        temp  LIKE gv_dec
        humi  LIKE gv_dec
        press LIKE gv_dec.

ENDCLASS.

CLASS lcl_statisticsdisplay IMPLEMENTATION.

  METHOD constructor.

    subject = im_subject.
    subject->registerobserver( im_observer = me ).

  ENDMETHOD.

  METHOD lif_observer~update.

    me->calculate_value(
      EXPORTING
        temp  = im_temp
        humi  = im_humi
        press = im_pres
    ).

    me->lif_displayelement~display( ).

  ENDMETHOD.

  METHOD lif_displayelement~display.

    WRITE  : /
                'Temperature min : '
                && ' ' && me->min_temp
                && 'Temperature max : '
                && ' ' && me->max_temp
                && 'Temperature avg : '
                && ' ' && me->avg_temp
                && 'Humidity min :'
                && ' ' && me->min_hum
                && 'Humidity max : '
                && ' ' && me->max_hum
                && 'Humidity avg : '
                && ' ' && me->avg_hum
                && 'Pressure min  :'
                && ' ' && me->min_pres
                && 'Pressure max  :'
                && ' ' && me->max_pres
                && 'Pressure avg  :'
                && ' ' && me->avg_pres.

    ULINE.

  ENDMETHOD.

  METHOD calculate_value.

    DATA : lv_sum_temp LIKE gv_dec,
           lv_sum_humi LIKE gv_dec,
           lv_sum_pres LIKE gv_dec,
           lv_count    TYPE i.

    APPEND VALUE zae_s_weather_cond( temp  = temp
                                     humi  = humi
                                     press = press )
                                 TO mt_stat_data.


    LOOP AT mt_stat_data ASSIGNING FIELD-SYMBOL(<data>).

      AT NEW temp.

        IF <data>-temp < me->min_temp.

          me->min_temp = <data>-temp.

        ENDIF.

        IF <data>-temp > me->max_temp.

          me->max_temp = <data>-temp.

        ENDIF.

      ENDAT.

      AT NEW humi.

        IF <data>-humi < me->min_hum.

          me->min_hum = <data>-humi.

        ENDIF.

        IF <data>-humi > me->max_hum.

          me->max_hum = <data>-humi.

        ENDIF.

      ENDAT.

      AT NEW press.

        IF <data>-press < me->min_pres.

          me->min_pres = <data>-press.

        ENDIF.

        IF <data>-press > me->max_pres.

          me->max_pres = <data>-press.

        ENDIF.

      ENDAT.

      lv_count = lv_count + 1.

      lv_sum_temp = lv_sum_temp + <data>-temp.

      lv_sum_humi = lv_sum_humi + <data>-humi.

      lv_sum_pres = lv_sum_pres + <data>-press.

    ENDLOOP.

    avg_hum = lv_sum_humi / lv_count .
    avg_pres = lv_sum_pres / lv_count .
    avg_temp = lv_sum_temp / lv_count .

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_forecastdisplay DEFINITION .
  PUBLIC SECTION.

    INTERFACES : lif_observer,
      lif_displayelement.

    METHODS : constructor IMPORTING VALUE(im_subject) TYPE REF TO lif_subject.

  PRIVATE SECTION.

    DATA : pressure LIKE gv_dec,
           subject  TYPE REF TO lif_subject.

ENDCLASS.

CLASS lcl_forecastdisplay IMPLEMENTATION.

  METHOD constructor.

    subject = im_subject.
    subject->registerobserver( im_observer = me ).

  ENDMETHOD.

  METHOD lif_observer~update.

    me->pressure = im_pres .

    me->lif_displayelement~display( ).

  ENDMETHOD.

  METHOD lif_displayelement~display.

    WRITE : / 'Current forecast :'
              && me->pressure .

    ULINE.

  ENDMETHOD.

ENDCLASS.
**********************************************************************


CLASS lcl_thirdparty DEFINITION .
  PUBLIC SECTION.

    INTERFACES : lif_observer,
      lif_displayelement.

    METHODS : constructor IMPORTING VALUE(im_subject) TYPE REF TO lif_subject.

  PRIVATE SECTION.

    DATA : pressure    LIKE gv_dec,
           temperature LIKE gv_dec,
           humidity    LIKE gv_dec,
           subject     TYPE REF TO lif_subject.

ENDCLASS.

CLASS lcl_thirdparty IMPLEMENTATION.

  METHOD constructor.

    subject = im_subject.
    subject->registerobserver( im_observer = me ).

  ENDMETHOD.

  METHOD lif_observer~update.

    me->pressure = im_pres .
    me->humidity = im_humi.
    me->temperature = im_temp.

    me->lif_displayelement~display( ).

  ENDMETHOD.

  METHOD lif_displayelement~display.

    WRITE : / 'Current barometer pressure for thirdparty : '
              && me->pressure
              && 'Current humidity for thirdparty : '
              && me->humidity
              && 'Current temperature for thirdparty : '
              && me->temperature .

    ULINE.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_heatindexdisplay DEFINITION .
  PUBLIC SECTION.

    INTERFACES : lif_observer,
      lif_displayelement.

    METHODS : constructor IMPORTING VALUE(im_subject) TYPE REF TO lif_subject.

  PRIVATE SECTION.

    DATA : pressure    LIKE gv_dec,
           temperature LIKE gv_dec,
           humidity    LIKE gv_dec,
           heatindex   LIKE gv_dec,
           subject     TYPE REF TO lif_subject.
    METHODS : computeheatindex .

ENDCLASS.

CLASS lcl_heatindexdisplay IMPLEMENTATION.

  METHOD constructor.

    subject = im_subject.
    subject->registerobserver( im_observer = me ).

  ENDMETHOD.

  METHOD lif_observer~update.

    me->pressure        = im_pres .
    me->humidity        = im_humi.
    me->temperature     = im_temp.

    me->computeheatindex( ).

    me->lif_displayelement~display( ).

  ENDMETHOD.

  METHOD lif_displayelement~display.

    WRITE : / 'Current heatindex : ' &&
               me->heatindex .

    ULINE.

  ENDMETHOD.

  METHOD computeheatindex.

    CONSTANTS :  c_1 TYPE p LENGTH 5 DECIMALS 3 VALUE '16.293',
                 c_2 TYPE p LENGTH 7 DECIMALS 6 VALUE '0.185212',
                 c_3 TYPE p LENGTH 6 DECIMALS 5 VALUE '5.37941',
                 c_4 TYPE p LENGTH 7 DECIMALS 6 VALUE '0.100254'.


    me->heatindex =   ( ( c_1 + ( c_2 * me->temperature ) + ( c_3 * me->humidity )
                      - ( c_4 * me->temperature * me->humidity ) ) ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_weatherdata DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_subject.

    METHODS: measuremenchanged ,
      setmeasurements IMPORTING VALUE(im_temp) LIKE gv_dec
                                VALUE(im_humi) LIKE gv_dec
                                VALUE(im_pres) LIKE gv_dec.

  PRIVATE SECTION.

    DATA : mt_observers TYPE TABLE OF REF TO lif_observer,
           temperature  LIKE gv_dec,
           humidity     LIKE gv_dec,
           pressure     LIKE gv_dec.

ENDCLASS.

CLASS lcl_weatherdata IMPLEMENTATION.

  METHOD measuremenchanged.

* grabbing data simulator

    me->lif_subject~notifyobserver( ).

  ENDMETHOD.

  METHOD lif_subject~registerobserver.

    APPEND im_observer TO mt_observers.

  ENDMETHOD.

  METHOD lif_subject~removeobserver.

    DATA lv_index TYPE i .

    LOOP AT mt_observers ASSIGNING FIELD-SYMBOL(<observers>).

      ADD 1 TO lv_index.

      IF <observers> EQ im_observer.

        EXIT.

      ENDIF.

    ENDLOOP.

    IF lv_index >= 0.

      DELETE mt_observers INDEX lv_index.

    ENDIF.

  ENDMETHOD.

  METHOD lif_subject~notifyobserver.

    DATA lr_observers TYPE REF TO lif_observer.

    LOOP AT mt_observers ASSIGNING FIELD-SYMBOL(<observers>).

      <observers>->update(
        EXPORTING
          im_temp = me->temperature
          im_humi = me->humidity
          im_pres = me->pressure
      ).

    ENDLOOP.

  ENDMETHOD.

  METHOD setmeasurements.

    me->temperature = im_temp.
    me->pressure = im_pres.
    me->humidity = im_humi.

    me->measuremenchanged( ).

  ENDMETHOD.

ENDCLASS.
