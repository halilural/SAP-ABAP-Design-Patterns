**********************************************************************
***********************INTERFACES FOR BEHAVIOURS**********************
**********************************************************************

INTERFACE lif_flybehaviour.

  METHODS : fly.

ENDINTERFACE.

INTERFACE lif_quackbehaviour.

  METHODS : quack .

ENDINTERFACE.

**********************************************************************
********************BEHAVIOUR RESPECTIVE CLASS************************
**********************************************************************

CLASS lcl_flywithwings DEFINITION.

  PUBLIC SECTION.
    INTERFACES : lif_flybehaviour.

ENDCLASS.

CLASS lcl_flywithwings IMPLEMENTATION.

  METHOD lif_flybehaviour~fly.

    WRITE : / 'Flying...'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_flynoway DEFINITION.

  PUBLIC SECTION.
    INTERFACES : lif_flybehaviour.

ENDCLASS.

CLASS lcl_flynoway IMPLEMENTATION.

  METHOD lif_flybehaviour~fly.

    WRITE : / 'Dont fly...'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_flyrocketpowered DEFINITION.

  PUBLIC SECTION.
    INTERFACES : lif_flybehaviour.

ENDCLASS.

CLASS lcl_flyrocketpowered IMPLEMENTATION.

  METHOD lif_flybehaviour~fly.

    WRITE : / 'fly rocketing...'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_quack DEFINITION .

  PUBLIC SECTION.
    INTERFACES : lif_quackbehaviour.

ENDCLASS.

CLASS lcl_quack IMPLEMENTATION.

  METHOD lif_quackbehaviour~quack.

    WRITE : / 'Quacking...'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_squeak DEFINITION.

  PUBLIC SECTION.
    INTERFACES: lif_quackbehaviour.

ENDCLASS.

CLASS lcl_squeak IMPLEMENTATION.

  METHOD lif_quackbehaviour~quack.

    WRITE : / 'Squeaking...'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_mutequack DEFINITION.
  PUBLIC SECTION.
    INTERFACES : lif_quackbehaviour.

ENDCLASS.

CLASS lcl_mutequack IMPLEMENTATION.

  METHOD lif_quackbehaviour~quack.

    WRITE : / 'Mutequacking...'.

  ENDMETHOD.

ENDCLASS.

**********************************************************************
***********************DUCK BASE CLASS********************************
**********************************************************************

CLASS lcl_duck  DEFINITION ABSTRACT.

  PUBLIC SECTION.
    METHODS :
      constructor,
      swim FINAL,
      display ABSTRACT,
      performquack,
      performfly,
      setflybehaviour
        IMPORTING VALUE(im_fb) TYPE REF TO lif_flybehaviour,
      setquackbehaviour
        IMPORTING VALUE(im_qb) TYPE REF TO lif_quackbehaviour .
*    Other duck-like methods

  PROTECTED SECTION.

    DATA fly_behaviour TYPE REF TO lif_flybehaviour.
    DATA quack_behaviour TYPE REF TO lif_quackbehaviour.

ENDCLASS.


CLASS lcl_duck IMPLEMENTATION.

  METHOD swim.

    WRITE : / 'All ducks float  , even decoys!'.

  ENDMETHOD.

  METHOD constructor.

  ENDMETHOD.

  METHOD performquack.

    quack_behaviour->quack( ).

  ENDMETHOD.

  METHOD performfly.

    fly_behaviour->fly( ).

  ENDMETHOD.

  METHOD setflybehaviour.

    fly_behaviour = im_fb.

  ENDMETHOD.

  METHOD setquackbehaviour.

    quack_behaviour = im_qb.

  ENDMETHOD.

ENDCLASS.

**********************************************************************
***************************SUB CLASSES FOR DUCK***********************
**********************************************************************

CLASS lcl_mallardduck DEFINITION INHERITING FROM lcl_duck.

  PUBLIC SECTION.

    METHODS : constructor,
      display FINAL REDEFINITION .

ENDCLASS.

CLASS lcl_mallardduck IMPLEMENTATION.

  METHOD display.

    WRITE :/ 'I am a real Mallard duck!'.

  ENDMETHOD.

  METHOD constructor.

* You have to call super constructor before calling this constructor .

    super->constructor( ).

* Duck's quack behaivour is real live quack so it is encapsulated.

*   We have just added to base class setter and getter method for this purpose .
    quack_behaviour = NEW lcl_quack( ).
    fly_behaviour = NEW lcl_flywithwings( ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_redheadduck DEFINITION INHERITING FROM lcl_duck.
  PUBLIC SECTION.

    METHODS : constructor,
      display FINAL REDEFINITION.

ENDCLASS.


CLASS  lcl_redheadduck IMPLEMENTATION.

  METHOD display.

    WRITE :/ 'I am a real ReadHead duck!'.

  ENDMETHOD.

  METHOD constructor.

    super->constructor( ).

*   We have just added to base class setter and getter method for this purpose .
    quack_behaviour = NEW lcl_quack( ).
    fly_behaviour = NEW lcl_flywithwings( ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_rubberduck DEFINITION INHERITING FROM lcl_duck.
  PUBLIC SECTION.

    METHODS :   constructor,
      display FINAL REDEFINITION .

ENDCLASS.

CLASS lcl_rubberduck IMPLEMENTATION.

  METHOD display.

    WRITE :/ 'I am a real Rubber duck!'.

  ENDMETHOD.

  METHOD constructor.

    super->constructor( ).

*   We have just added to base class setter and getter method for this purpose .
    quack_behaviour = NEW lcl_quack( ).
    fly_behaviour = NEW lcl_flynoway( ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_decoyduck DEFINITION INHERITING FROM lcl_duck.

  PUBLIC SECTION.

    METHODS :  constructor,
      display FINAL REDEFINITION.

ENDCLASS.

CLASS lcl_decoyduck IMPLEMENTATION.

  METHOD display.

  ENDMETHOD.

  METHOD constructor.

    super->constructor( ).

*   We have just added to base class setter and getter method for this purpose .
    quack_behaviour = NEW lcl_mutequack( ).
    fly_behaviour = NEW lcl_flynoway( ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************

CLASS lcl_modelduck DEFINITION INHERITING FROM lcl_duck.
  PUBLIC SECTION.
    METHODS:    constructor ,
      display REDEFINITION.

ENDCLASS.

CLASS lcl_modelduck IMPLEMENTATION.

  METHOD display.

    WRITE :/ 'I am a model duck !'.

  ENDMETHOD.

  METHOD constructor.

    super->constructor( ).

    quack_behaviour = NEW lcl_quack( ).
    fly_behaviour = NEW lcl_flynoway( ).

  ENDMETHOD.

ENDCLASS.

**********************************************************************
