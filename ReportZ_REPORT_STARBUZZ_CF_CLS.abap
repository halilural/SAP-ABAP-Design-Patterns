**********************************************************************
********************BASE CLASS FOR BEVERAGE***************************
**********************************************************************

CLASS lcl_beverage DEFINITION ABSTRACT.
  PUBLIC SECTION.
    TYPES : type_cost TYPE p LENGTH 6 DECIMALS 2.
    METHODS :
      getdescription RETURNING VALUE(re_value) TYPE char50,
      cost ABSTRACT  RETURNING VALUE(re_value) TYPE type_cost,
      contrustor IMPORTING VALUE(im_size) TYPE z_size ,
      getsize RETURNING VALUE(re_value) TYPE z_size,
      setsize IMPORTING VALUE(im_value) TYPE z_size.

  PROTECTED  SECTION.

    DATA description TYPE char50 VALUE 'Unknown Beverage!'.

  PRIVATE SECTION.

    DATA size TYPE z_size.

ENDCLASS.

CLASS lcl_beverage IMPLEMENTATION.

  METHOD getdescription.

    re_value = me->description.

  ENDMETHOD.

  METHOD contrustor.

    me->setsize( im_value = im_size ).

  ENDMETHOD.

  METHOD getsize.

    re_value = size.

  ENDMETHOD.

  METHOD setsize.

    size = im_value.

  ENDMETHOD.

ENDCLASS.


**********************************************************************
************************CONDIMENT DECORATOR***************************
**********************************************************************

CLASS lcl_condimentdecorator DEFINITION ABSTRACT INHERITING FROM lcl_beverage.
  PUBLIC SECTION.
    METHODS: cost REDEFINITION,
      getdescription REDEFINITION.

ENDCLASS.

CLASS lcl_condimentdecorator IMPLEMENTATION.

  METHOD cost.

  ENDMETHOD.

  METHOD getdescription.

  ENDMETHOD.

ENDCLASS.
**********************************************************************
CLASS lcl_mocha DEFINITION INHERITING FROM lcl_condimentdecorator.
  PUBLIC SECTION.
    METHODS : constructor IMPORTING VALUE(im_beverage) TYPE REF TO lcl_beverage,
      getdescription REDEFINITION,
      cost REDEFINITION,
      getsize REDEFINITION.

  PRIVATE SECTION.

    DATA beverage TYPE REF TO lcl_beverage.

ENDCLASS.

CLASS lcl_mocha IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    me->beverage = im_beverage.

  ENDMETHOD.

  METHOD getdescription.

    WRITE : / me->beverage->getdescription( ) , ', Mocha'.

  ENDMETHOD.

  METHOD cost.

    DATA lv_cost TYPE type_cost .

    CLEAR lv_cost.

    lv_cost = me->beverage->cost( ).

    IF me->getsize( ) EQ 1.  "This means if beverage has actually Tall Size

      re_value = lv_cost + '0.10'.

    ELSEIF me->getsize( ) EQ 2. "This means if beveare has actually Grande Size

      re_value = lv_cost + '0.20'.

    ELSEIF me->getsize( ) EQ 3. "This means if beverage has actually Venti Size

      re_value = lv_cost + '0.30'.

    ENDIF.

  ENDMETHOD.

  METHOD getsize.

    re_value = beverage->getsize( ).

  ENDMETHOD.

ENDCLASS.
**********************************************************************
CLASS lcl_whip DEFINITION INHERITING FROM lcl_condimentdecorator.
  PUBLIC SECTION.
    METHODS : constructor IMPORTING VALUE(im_beverage) TYPE REF TO lcl_beverage,
      getdescription REDEFINITION,
      cost REDEFINITION,
      getsize REDEFINITION.

  PRIVATE SECTION.

    DATA beverage TYPE REF TO lcl_beverage.

ENDCLASS.

CLASS lcl_whip IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    me->beverage = im_beverage.

  ENDMETHOD.

  METHOD getdescription.

    WRITE : / me->beverage->getdescription( ) , ', Whip'.

  ENDMETHOD.

  METHOD cost.

    DATA lv_cost TYPE type_cost .

    CLEAR lv_cost.

    lv_cost = me->beverage->cost( ).

    IF me->getsize( ) EQ 1.  "This means if beverage has actually Tall Size

      re_value = lv_cost + '0.10'.

    ELSEIF me->getsize( ) EQ 2. "This means if beveare has actually Grande Size

      re_value = lv_cost + '0.20'.

    ELSEIF me->getsize( ) EQ 3. "This means if beverage has actually Venti Size

      re_value = lv_cost + '0.30'.

    ENDIF.
  ENDMETHOD.

  METHOD getsize.

    re_value = beverage->getsize( ).

  ENDMETHOD.

ENDCLASS.
**********************************************************************
CLASS lcl_soy DEFINITION INHERITING FROM lcl_condimentdecorator.
  PUBLIC SECTION.
    METHODS : constructor IMPORTING VALUE(im_beverage) TYPE REF TO lcl_beverage,
      getdescription REDEFINITION,
      cost REDEFINITION,
      getsize REDEFINITION.

  PRIVATE SECTION.

    DATA beverage TYPE REF TO lcl_beverage.

ENDCLASS.

CLASS lcl_soy IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    me->beverage = im_beverage.

  ENDMETHOD.

  METHOD getdescription.

    WRITE : / me->beverage->getdescription( ) , ', Soy'.

  ENDMETHOD.

  METHOD cost.

    DATA lv_cost TYPE type_cost .

    CLEAR lv_cost.

    lv_cost = me->beverage->cost( ).

    IF me->getsize( ) EQ 1.  "This means if beverage has actually Tall Size

      re_value = lv_cost + '0.10'.

    ELSEIF me->getsize( ) EQ 2. "This means if beveare has actually Grande Size

      re_value = lv_cost + '0.20'.

    ELSEIF me->getsize( ) EQ 3. "This means if beverage has actually Venti Size

      re_value = lv_cost + '0.30'.

    ENDIF.

  ENDMETHOD.

  METHOD getsize.

    re_value = beverage->getsize( ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************
*************************SUB CLASSES FOR BEVERAGE*********************
**********************************************************************

CLASS lcl_houseblend DEFINITION INHERITING FROM lcl_beverage.
  PUBLIC SECTION.
    METHODS: cost REDEFINITION,
      constructor.

ENDCLASS.

CLASS lcl_houseblend IMPLEMENTATION.

  METHOD cost.

    re_value = '0.89'.

  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).

    me->description = 'House Blend Coffee'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_darkroast DEFINITION INHERITING FROM lcl_beverage.
  PUBLIC SECTION.
    METHODS: cost REDEFINITION.
    METHODS constructor.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_darkroast IMPLEMENTATION.

  METHOD cost.

    re_value = '0.89'.

  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).

    me->description = 'Dark Roast'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_decaf DEFINITION INHERITING FROM lcl_beverage.
  PUBLIC SECTION.
    METHODS: cost REDEFINITION.
    METHODS constructor.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_decaf IMPLEMENTATION.

  METHOD cost.

    re_value = '0.89'.

  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).

    me->description = 'Decaf'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_espresso DEFINITION INHERITING FROM lcl_beverage.
  PUBLIC SECTION.
    METHODS: cost REDEFINITION,
      constructor.

ENDCLASS.

CLASS lcl_espresso IMPLEMENTATION.

  METHOD cost.

    re_value = '1.99'.

  ENDMETHOD.

  METHOD constructor.

    super->constructor( ).

    me->description = 'Espresso'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************
