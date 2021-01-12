CLASS lhc_Subobject DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS FillRequest FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Subobject~FillRequest.
    METHODS AddSubobject FOR DETERMINE ON SAVE
      IMPORTING keys FOR Subobject~AddSubobject.

ENDCLASS.

CLASS lhc_Subobject IMPLEMENTATION.

  METHOD FillRequest.

    DATA lt_modify TYPE TABLE FOR UPDATE  zi_subobject.
    DATA ls_modify LIKE LINE OF lt_modify.

    READ ENTITIES OF zi_object IN LOCAL MODE
          ENTITY Subobject
            FIELDS ( TransportRequest )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_subobject).

    READ ENTITIES OF zi_object IN LOCAL MODE
      ENTITY Subobject BY \_Object
        FIELDS ( TransportRequest )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_requests).



    LOOP AT lt_subobject INTO DATA(ls_subobject).
      IF ls_subobject-TransportRequest IS INITIAL.
        ls_modify = VALUE #( %tky = ls_subobject-%tky
                             TransportRequest = lt_requests[ %data-ObjectUuid = ls_subobject-%data-ObjectUuid ]-TransportRequest ).
        APPEND ls_modify TO lt_modify.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zi_object IN LOCAL MODE
          ENTITY Subobject
            UPDATE FIELDS ( TransportRequest )
            WITH lt_modify
        REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD AddSubobject.

    READ ENTITIES OF zi_object IN LOCAL MODE
            ENTITY Subobject
              FIELDS ( Subobject
                       SubobjectText
                       TransportRequest )
            WITH CORRESPONDING #( keys )
          RESULT DATA(lt_subobject).

    READ ENTITIES OF zi_object IN LOCAL MODE
           ENTITY Subobject BY \_Object
             FIELDS ( Object )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_objects).

    IF lt_subobject IS NOT INITIAL.
      DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).

      LOOP AT lt_subobject INTO DATA(ls_subobject).

        TRY.
            lo_log_object->add_subobject( EXPORTING iv_object = lt_objects[ %data-ObjectUuid = ls_subobject-%data-ObjectUuid ]-Object
                                                    iv_subobject = ls_subobject-Subobject
                                                    iv_subobject_text = ls_subobject-SubobjectText
                                                    iv_transport_request = ls_subobject-TransportRequest ).
          CATCH cx_bali_objects INTO DATA(lx_exception).
            "WRITE lx_exception->get_text( ).
        ENDTRY.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.



ENDCLASS.
