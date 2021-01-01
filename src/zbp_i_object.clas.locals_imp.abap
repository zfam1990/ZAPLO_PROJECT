CLASS lhc_Object DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CreateApplObject FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Object~CreateApplObject.

      METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Object RESULT result.

ENDCLASS.

CLASS lhc_Object IMPLEMENTATION.

  METHOD CreateApplObject.

    READ ENTITIES OF zi_object IN LOCAL MODE
          ENTITY Object
            FIELDS ( Object
                     ObjectText
                     PackageObj
                     TransportRequest )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_object).

    IF lt_object IS NOT INITIAL.
      DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).

      LOOP AT lt_object INTO DATA(ls_object).
        TRY.
            lo_log_object->create_object( EXPORTING iv_object = ls_object-Object
                                                    iv_object_text = ls_object-ObjectText
                                                    iv_package = ls_object-PackageObj
                                                    iv_transport_request = ls_object-TransportRequest ).
          CATCH cx_bali_objects INTO DATA(lx_exception).
            "WRITE lx_exception->get_text( ).
        ENDTRY.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD get_features.
  ENDMETHOD.


ENDCLASS.
