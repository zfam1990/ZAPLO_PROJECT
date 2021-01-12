CLASS lhc_Object DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CreateApplObject FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Object~CreateApplObject.

    METHODS FillObject FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Object~FillObject.

    METHODS CreateSubobject FOR DETERMINE ON SAVE
      IMPORTING keys FOR Object~CreateSubobject.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Object RESULT result.

*          METHODS validateObject FOR VALIDATE ON SAVE
*      IMPORTING keys FOR Object~validateObject.

ENDCLASS.

CLASS lhc_Object IMPLEMENTATION.

*METHOD validateObject.
*
*    READ ENTITIES OF zi_object IN LOCAL MODE
*                  ENTITY Object
*                    FIELDS ( Object )
*                  WITH CORRESPONDING #( keys )
*                RESULT DATA(lt_objects).
*
*    DATA lt_object TYPE SORTED TABLE OF zobject WITH UNIQUE KEY object_uuid.
*
*    " Optimization of DB select: extract distinct non-initial supplier IDs
*    lt_object = CORRESPONDING #( lt_objects DISCARDING DUPLICATES MAPPING object_uuid = objectuuid ).
*
*    DELETE lt_object WHERE object IS INITIAL.
*    CHECK lt_object IS NOT INITIAL.
*
*    " Check if supplier ID exist
*    SELECT FROM zobject FIELDS distinct object
*      FOR ALL ENTRIES IN @lt_object
*        WHERE object = @lt_object-object
*      INTO TABLE @DATA(lt_object_db).
*
*    " Raise msg for non supplier id
*    LOOP AT lt_objects INTO DATA(ls_objects).
*      IF ls_objects-Object IS NOT INITIAL AND line_exists( lt_object_db[ object = ls_objects-Object ] ).
*        APPEND VALUE #(  %tky = ls_objects-%tky ) TO failed-object.
*        APPEND VALUE #(  %tky = ls_objects-%tky
*                         %msg      = new_message( id        = 'ZM_APPL_OBJECT'
*                                             number    = '001'
*
*                                             severity  = if_abap_behv_message=>severity-error )
*                         %element-object = if_abap_behv=>mk-on ) TO reported-object.
*      ENDIF.
*
*    ENDLOOP.
*
*ENDMETHOD.

  METHOD FillObject.

    DATA lt_modify TYPE TABLE FOR UPDATE  zi_object.
    DATA ls_modify LIKE LINE OF lt_modify.

    READ ENTITIES OF zi_object IN LOCAL MODE
              ENTITY Object
                FIELDS ( Object )
              WITH CORRESPONDING #( keys )
            RESULT DATA(lt_object).

    IF lt_object IS NOT INITIAL.

      DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).
      LOOP AT lt_object INTO DATA(ls_object).

        DATA(lv_object) = ls_object-Object.

        TRY.
            lo_log_object->read_object(
            EXPORTING
            iv_object = lv_object
            IMPORTING
            ev_object_text = DATA(lv_object_text)
            et_subobjects = DATA(lt_subobjects) ).

          CATCH cx_bali_objects INTO DATA(lx_exception).
        ENDTRY.
        IF lv_object_text IS NOT INITIAL.
          ls_modify = VALUE #( %tky = ls_object-%tky
                                 ObjectText = lv_object_text ).
          APPEND ls_modify TO lt_modify.
          CLEAR lv_object_text.
        ENDIF.
      ENDLOOP.

      MODIFY ENTITIES OF zi_object IN LOCAL MODE
            ENTITY Object
              UPDATE FIELDS ( ObjectText )
              WITH lt_modify
          REPORTED DATA(lt_reported).
    ENDIF.

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD CreateSubobject.

    DATA lt_modify TYPE TABLE FOR CREATE zi_object\_Subobject.

    DATA ls_modify LIKE LINE OF lt_modify.

    READ ENTITIES OF zi_object IN LOCAL MODE
                  ENTITY Object
                    FIELDS ( Object )
                  WITH CORRESPONDING #( keys )
                RESULT DATA(lt_object).

    DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).
    LOOP AT lt_object INTO DATA(ls_object).

      DATA(lv_object) = ls_object-Object.

      TRY.
          lo_log_object->read_object(
          EXPORTING
          iv_object = lv_object
          IMPORTING
          ev_object_text = DATA(lv_object_text)
          et_subobjects = DATA(lt_subobjects) ).

        CATCH cx_bali_objects INTO DATA(lx_exception).
      ENDTRY.
      IF lt_subobjects IS NOT INITIAL.
        ls_modify = VALUE #( %key = ls_object-%key
                          %target = VALUE #( FOR ls_subobjects IN lt_subobjects
                          ( %data-Subobject = ls_subobjects-subobject
                          %data-SubobjectText = ls_subobjects-subobject_text ) ) ).

        APPEND ls_modify TO lt_modify.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_object IN LOCAL MODE
      ENTITY Object
        CREATE BY \_Subobject
        FIELDS ( Subobject
                 SubobjectText )
        WITH lt_modify
    REPORTED DATA(lt_reported).

  ENDMETHOD.

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
