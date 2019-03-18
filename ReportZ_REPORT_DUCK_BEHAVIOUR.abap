REPORT z_report_duck_behaviour
        NO STANDARD PAGE HEADING.

**********************************************************************
********************STRAGETY PATTERN**********************************
**********************************************************************

INCLUDE z_report_duck_behaviour_cls.

INITIALIZATION.

START-OF-SELECTION.

  PERFORM mini_duck_simulator .

END-OF-SELECTION.

FORM mini_duck_simulator.

* Kapsülleme için tipler base class referansında tanımlanıyor.

  DATA lr_mallard TYPE REF TO lcl_duck.
  DATA lr_model   TYPE REF TO lcl_duck.

* mallard tipinde duck , instantiate ediliyor .

       lr_mallard = NEW lcl_mallardduck( ).

  lr_mallard->performfly( ).
  lr_mallard->performquack( ).

* model tipinde duck , instantiate ediliyor .

  lr_model = NEW lcl_modelduck( ).

  lr_model->performfly( ).

* model ' in fly behaviour ' u runtime 'da yeniden set ediliyor . (Setter metodu ile ).

  lr_model->setflybehaviour( im_fb = NEW lcl_flyrocketpowered( ) ).

  lr_model->performfly( ).

ENDFORM.
