CLASS zcl_generate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generate IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zlogstatus.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( status_id = '1' status_name = 'Activate' )
      ( status_id = '2' status_name = 'Deactivate' ) ).


*   delete existing entries in the database table
    DELETE FROM zlogstatus.

*   insert the new table entries
    INSERT zlogstatus FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } travel entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
