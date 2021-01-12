CLASS lhc_Subobject DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS FillRequest FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Subobject~FillRequest.

ENDCLASS.

CLASS lhc_Subobject IMPLEMENTATION.

  METHOD FillRequest.

      DATA lt_modify TYPE TABLE FOR UPDATE  zi_subobject1.
    DATA ls_modify LIKE LINE OF lt_modify.

    READ ENTITIES OF zi_object1 IN LOCAL MODE
          ENTITY Subobject
            FIELDS ( TransportRequest )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_subobject).

    READ ENTITIES OF zi_object1 IN LOCAL MODE
      ENTITY Subobject BY \_Object
        FIELDS ( TransportRequest )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_requests).



    LOOP AT lt_subobject INTO DATA(ls_subobject).
      IF ls_subobject-TransportRequest IS INITIAL.
        ls_modify = VALUE #( %tky = ls_subobject-%tky
                             TransportRequest = lt_requests[ %data-Object = ls_subobject-%data-Object ]-TransportRequest ).
        APPEND ls_modify TO lt_modify.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zi_object1 IN LOCAL MODE
          ENTITY Subobject
            UPDATE FIELDS ( TransportRequest )
            WITH lt_modify
        REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.
