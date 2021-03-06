CLASS lcl_toppings DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS :
      constructor IMPORTING VALUE(im_value) TYPE char30,
      gettoptype  RETURNING VALUE(re_value) TYPE char30.

  PRIVATE SECTION .

    DATA topptype TYPE char30.

ENDCLASS.

CLASS lcl_toppings IMPLEMENTATION.

  METHOD constructor.

    me->topptype = im_value.

  ENDMETHOD.

  METHOD gettoptype.

    re_value = me->topptype.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_pizza DEFINITION ABSTRACT.

  PUBLIC SECTION.

    TYPES  : BEGIN OF ty_toppings,
               topptype TYPE REF TO lcl_toppings,
             END OF ty_toppings,

             tt_toppings TYPE STANDARD TABLE OF ty_toppings.

    METHODS :
      prepare,
      bake,
      cut,
      box,
      getname FINAL RETURNING VALUE(re_value) TYPE string.

  PROTECTED SECTION.

    DATA : name     TYPE string,
           dough    TYPE string,
           sauce    TYPE string,
           toppings TYPE tt_toppings.
ENDCLASS.

CLASS lcl_pizza IMPLEMENTATION.

  METHOD prepare.

    DATA lv_count TYPE i.

    CLEAR lv_count.

    WRITE  :/ 'Preparing ' && me->name .
    NEW-LINE NO-SCROLLING.
    WRITE :/ 'Tossing dough...'.
    NEW-LINE NO-SCROLLING.
    WRITE :/ 'Adding sauce...'.
    NEW-LINE NO-SCROLLING.
    WRITE :/ 'Adding toppings'.
    NEW-LINE NO-SCROLLING.

    IF lines( toppings ) > 0 .

      WHILE lv_count < lines( toppings ).

        DATA(lv_toptype) = toppings[ lv_count + 1 ]-topptype.

        WRITE :/ '    '  , lv_toptype->gettoptype( ) .

        NEW-LINE NO-SCROLLING.

        ADD 1 TO lv_count.

      ENDWHILE.

    ELSE.

      WRITE : / 'Not found toppings'.

    ENDIF.

  ENDMETHOD.

  METHOD bake.

    WRITE :/ 'Bake for 25 minutes at 350'.

  ENDMETHOD.

  METHOD cut.

    WRITE :/ 'Cutting pizza into diagonal slices'.

  ENDMETHOD.

  METHOD box.

    WRITE :/ 'Place pizza in official PizzaStore Box'.

  ENDMETHOD.

  METHOD getname.

    re_value = me->name.

  ENDMETHOD.

ENDCLASS.

**********************************************************************


CLASS lcl_nystylecheesepizza DEFINITION INHERITING FROM lcl_pizza.
  PUBLIC SECTION.
    METHODS : constructor .


ENDCLASS.

CLASS lcl_nystylecheesepizza IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    name    = 'NY Style Sauce and Cheese Pizza'.
    dough   = 'Thin Crust Dough'.
    sauce   = 'Marinara Sauce'.

    toppings = VALUE #( ( topptype = NEW lcl_toppings( im_value = 'Mushrooms' ) )
                        ( topptype = NEW lcl_toppings( im_value = 'Bacon' ) )
                        ( topptype = NEW lcl_toppings( im_value = 'Black olives' ) )
                        ( topptype = NEW lcl_toppings( im_value = 'Grated Reggiano Cheese' ) ) ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_chicstylecheesepizza DEFINITION INHERITING FROM lcl_pizza.

  PUBLIC SECTION.
    METHODS :
      constructor,
      cut REDEFINITION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_chicstylecheesepizza IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    name    = 'Chicago Style Deep Dish Cheese Pizza'.
    dough   = 'Extra Thick Crust Dough'.
    sauce   = 'Plum Tomato Sauce'.

    toppings = VALUE #( ( topptype = NEW lcl_toppings( im_value = 'Shredded Mozarella Cheese' ) )
                        ( topptype = NEW lcl_toppings( im_value = 'Bacon' ) )
                        ( topptype = NEW lcl_toppings( im_value = 'Black olives' ) ) ).

  ENDMETHOD.

  METHOD cut.

    WRITE :/ 'Cutting the pizza into square slices!'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_nystylepepperonipizza DEFINITION INHERITING FROM lcl_pizza.
  PUBLIC SECTION.

ENDCLASS.

CLASS lcl_nystylepepperonipizza IMPLEMENTATION.


ENDCLASS.

**********************************************************************

CLASS lcl_chicstylepepperonipizza DEFINITION INHERITING FROM lcl_pizza.
  PUBLIC SECTION.


ENDCLASS.

CLASS lcl_chicstylepepperonipizza IMPLEMENTATION.


ENDCLASS.

**********************************************************************

CLASS lcl_nystyleclampizza DEFINITION INHERITING FROM lcl_pizza.
  PUBLIC SECTION.

ENDCLASS.

CLASS lcl_nystyleclampizza IMPLEMENTATION.


ENDCLASS.

**********************************************************************

CLASS lcl_chicstyleclampizza DEFINITION INHERITING FROM lcl_pizza.
  PUBLIC SECTION.

ENDCLASS.

CLASS lcl_chicstyleclampizza IMPLEMENTATION.


ENDCLASS.

**********************************************************************

CLASS lcl_nystyleveggiepizza DEFINITION INHERITING FROM lcl_pizza .
  PUBLIC SECTION.

ENDCLASS.

CLASS lcl_nystyleveggiepizza IMPLEMENTATION.


ENDCLASS.

**********************************************************************

CLASS lcl_chicstyleveggiepizza DEFINITION INHERITING FROM lcl_pizza .
  PUBLIC SECTION.


ENDCLASS.

CLASS lcl_chicstyleveggiepizza IMPLEMENTATION.


ENDCLASS.


**********************************************************************
*******************CREATING SIMPLE PIZZA FACTORY**********************
**********************************************************************

CLASS lcl_pizzafactory DEFINITION .
  PUBLIC SECTION.
    METHODS : createpizza IMPORTING VALUE(im_value) TYPE string
                          RETURNING VALUE(re_pizza) TYPE REF TO lcl_pizza.

ENDCLASS.

CLASS lcl_pizzafactory IMPLEMENTATION.

  METHOD createpizza.

*    DATA lr_pizza TYPE REF TO lif_pizza.
*
*    CLEAR lr_pizza.
*
*    CASE im_value.
*
*      WHEN 'CHEESE'.
*
*        lr_pizza = NEW lcl_cheesepizza( ).
*
*      WHEN 'PEPPERONI'.
*
*        lr_pizza = NEW lcl_pepperonipizza( ).
*
*      WHEN 'CLAM'.
*
*        lr_pizza = NEW lcl_clampizza( ).
*
*      WHEN 'VEGGIE'.
*
*        lr_pizza = NEW lcl_veggiepizza( ).
*
*    ENDCASE.
*
*    re_pizza = lr_pizza.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_pizzastore DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS :orderpizza FINAL
      IMPORTING VALUE(im_pizzatype) TYPE string
      RETURNING VALUE(re_pizza)     TYPE REF TO lcl_pizza .

  PROTECTED SECTION.
    METHODS : createpizza ABSTRACT
      IMPORTING VALUE(im_type)  TYPE string
      RETURNING VALUE(re_pizza) TYPE REF TO lcl_pizza .

* We give PizzaStore a reference to a SimplePizzaFactory

*    DATA factory TYPE REF TO lcl_pizzafactory.

ENDCLASS.

CLASS lcl_pizzastore IMPLEMENTATION.

* Gets the factory passed to it in the constructor.

  METHOD orderpizza.

    DATA lr_pizza TYPE REF TO lcl_pizza.

* Now , Here pizza's factory is now abstract createpizza method

    lr_pizza = me->createpizza( im_type = im_pizzatype ).

    lr_pizza->prepare( ).
    lr_pizza->bake( ).
    lr_pizza->cut( ).
    lr_pizza->box( ).

    re_pizza = lr_pizza.

  ENDMETHOD.


ENDCLASS.

**********************************************************************
**********************************************************************
**********************************************************************

CLASS lcl_nystylepizzastore DEFINITION INHERITING FROM lcl_pizzastore.
  PROTECTED SECTION.
    METHODS: createpizza REDEFINITION.

ENDCLASS.

CLASS lcl_nystylepizzastore IMPLEMENTATION.

  METHOD createpizza.

    CASE im_type.

      WHEN 'CHEESE'.

        re_pizza = NEW lcl_nystylecheesepizza( ).

      WHEN 'PEPPERONI'.

        re_pizza = NEW lcl_nystylepepperonipizza( ).

      WHEN 'CLAM'.

        re_pizza = NEW lcl_nystyleclampizza( ).

      WHEN 'VEGGIE'.

        re_pizza = NEW lcl_nystyleveggiepizza( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_chicagostylepizzastore DEFINITION INHERITING FROM lcl_pizzastore.
  PROTECTED SECTION.
    METHODS: createpizza REDEFINITION.


ENDCLASS.

CLASS lcl_chicagostylepizzastore IMPLEMENTATION.

  METHOD createpizza.

    CASE im_type.

      WHEN 'CHEESE'.

        re_pizza = NEW lcl_chicstylecheesepizza( ).

      WHEN 'PEPPERONI'.

        re_pizza = NEW lcl_chicstylepepperonipizza( ).

      WHEN 'CLAM'.

        re_pizza = NEW lcl_chicstyleclampizza( ).

      WHEN 'VEGGIE'.

        re_pizza = NEW lcl_chicstyleveggiepizza( ).

    ENDCASE.

  ENDMETHOD.


ENDCLASS.

**********************************************************************
