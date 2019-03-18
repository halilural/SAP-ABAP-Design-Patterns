REPORT z_report_pizza_shop.


INCLUDE z_report_pizza_shop_cls.

DATA : lr_nypizzastore TYPE REF TO lcl_pizzastore,
       lr_chpizzastore TYPE REF TO lcl_pizzastore,
       lr_pizza        TYPE REF TO lcl_pizza.

START-OF-SELECTION.

* One customer wants Newyork style pizza , That's why ,
*I need to instantiate NYPizzaStore .

  lr_nypizzastore = NEW lcl_nystylepizzastore( ).

* Another customer wants Chicago style pizza , so i need
* to instantiate another PizzaStore like ChicagoPizza Store.

  lr_chpizzastore = NEW lcl_chicagostylepizzastore( ).

  lr_pizza = lr_nypizzastore->orderpizza( im_pizzatype = 'CHEESE' ).

  NEW-LINE NO-SCROLLING.

  ULINE.

  WRITE :/ 'Ethan ordered a ' && lr_pizza->getname( ) .

  NEW-LINE NO-SCROLLING.

  ULINE.

  lr_pizza = lr_chpizzastore->orderpizza( im_pizzatype = 'CHEESE' ).

  ULINE.

  WRITE :/ 'Joel ordered a ' && lr_pizza->getname( ) .

  ULINE.

  NEW-LINE NO-SCROLLING.
