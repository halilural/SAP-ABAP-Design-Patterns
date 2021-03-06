REPORT z_report_starbuzz_coffee_dec NO STANDARD PAGE HEADING.


INCLUDE z_report_starbuzz_cf_cls.

DATA lr_beverage    TYPE REF TO lcl_beverage.
DATA lr_beverage2   TYPE REF TO lcl_beverage.
DATA lr_beverage3   TYPE REF TO lcl_beverage.

START-OF-SELECTION.

* Getting new beverage for coffee machine or customer

  lr_beverage = NEW lcl_espresso( ).

* Determining coffee size

  lr_beverage->setsize( im_value = CONV z_size( 1 )  ).

* Get Description of beverage

  WRITE : / lr_beverage->getdescription( ).

* Instantiate new beverage for other customer

  lr_beverage2 = NEW lcl_darkroast( ).

*  * Determining coffee size

  lr_beverage2->setsize( im_value = CONV z_size( 2 )  ).

* Get Description of beverage

  WRITE : / lr_beverage2->getdescription( ).

* Instantiate new condiments for coffee

  lr_beverage2 = NEW lcl_mocha( im_beverage = lr_beverage2 ).
  lr_beverage2 = NEW lcl_mocha( im_beverage = lr_beverage2 ).
  lr_beverage2 = NEW lcl_whip( im_beverage =  lr_beverage2 ).

* Getting description from coffee again

  WRITE:/ lr_beverage2->getdescription( ) , ' $' , lr_beverage2->cost( ).

* Getting new beverage for coffee machine or customer

  lr_beverage3 = NEW lcl_houseblend( ).

* Determining coffee size

  lr_beverage3->setsize( im_value = CONV z_size( 3 )  ).

  lr_beverage3 = NEW lcl_soy(   im_beverage = lr_beverage3 ).
  lr_beverage3 = NEW lcl_mocha( im_beverage = lr_beverage3 ).
  lr_beverage3 = NEW lcl_whip(  im_beverage = lr_beverage3 ).

  WRITE:/ lr_beverage3->getdescription( ) , ' $' , lr_beverage3->cost( ).
