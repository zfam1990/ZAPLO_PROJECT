CLASS lhc_Subobject DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS FillRequest FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Subobject~FillRequest.
*    METHODS AddSubobject FOR DETERMINE ON SAVE
*      IMPORTING keys FOR Subobject~AddSubobject.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Subobject RESULT result.
    METHODS ActivateObject1 FOR MODIFY
      IMPORTING keys FOR ACTION Subobject~ActivateObject1 RESULT result.

    METHODS DeactivateObject FOR MODIFY
      IMPORTING keys FOR ACTION Subobject~DeactivateObject1 RESULT result.

    METHODS SetStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Subobject~SetStatus.

    METHODS DefaultStatus FOR MODIFY
      IMPORTING keys FOR ACTION Subobject~DefaultStatus.

ENDCLASS.

CLASS lhc_Subobject IMPLEMENTATION.

  METHOD DefaultStatus.

    DATA lt_modify TYPE TABLE FOR UPDATE  zi_subobject.
    DATA ls_modify LIKE LINE OF lt_modify.

    READ ENTITIES OF zi_object IN LOCAL MODE
            ENTITY Subobject
              FIELDS ( Subobject
                       SubobjectText
                       ObjectUuid )
            WITH CORRESPONDING #( keys )
          RESULT DATA(lt_subobject).

    READ ENTITIES OF zi_object IN LOCAL MODE
           ENTITY Subobject BY \_Object
             FIELDS ( Object )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_objects).

    LOOP AT lt_objects INTO DATA(ls_objects).

      DATA(lt_subobjects) = xco_cp_abap_repository=>object->aplo->for( ls_objects-Object )->subobjects->all->get_names( ).
      DATA(ls_subobject) = lt_subobject[ %data-ObjectUuid = ls_objects-%data-ObjectUuid ].
      DATA(lv_subobject_name) = ls_subobject-%data-Subobject.
      IF line_exists( lt_subobjects[ table_line = lv_subobject_name ] ) .

        ls_modify = VALUE #( %key = ls_subobject-%key
                                     LogObjectStatus = '01' ).

      ELSE.

        ls_modify = VALUE #( %key = ls_subobject-%key
                                     LogObjectStatus = '02' ).

      ENDIF.
      APPEND ls_modify TO lt_modify.
    ENDLOOP.

    MODIFY ENTITIES OF zi_object IN LOCAL MODE
          ENTITY Subobject
            UPDATE FIELDS ( LogObjectStatus )
            WITH lt_modify
        REPORTED DATA(lt_reported).


ENDMETHOD.
METHOD SetStatus.

  MODIFY ENTITIES OF zi_object IN LOCAL MODE
   ENTITY Subobject
     EXECUTE DefaultStatus
     FROM CORRESPONDING #( keys )
 REPORTED DATA(lt_reported).

  reported = CORRESPONDING #( DEEP lt_reported ).

ENDMETHOD.

METHOD DeactivateObject.
  DATA(lt_keys) = keys.

  READ ENTITIES OF zi_object IN LOCAL MODE
          ENTITY Subobject
            FIELDS ( Subobject
             ObjectUuid )
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
      DATA(ls_keys) = lt_keys[ %tky = ls_subobject-%tky ].
      DATA(lv_transport) = ls_keys-%param-transport_request.
      TRY.
          lo_log_object->delete_subobject( EXPORTING iv_object = lt_objects[ %data-ObjectUuid = ls_subobject-%data-ObjectUuid ]-Object
                                                  iv_subobject = ls_subobject-Subobject
                                                  iv_transport_request = lv_transport ).
        CATCH cx_bali_objects INTO DATA(lx_exception).
          "WRITE lx_exception->get_text( ).
      ENDTRY.
    ENDLOOP.
  ENDIF.
  MODIFY ENTITIES OF zi_object IN LOCAL MODE
    ENTITY Subobject
      UPDATE FROM VALUE #(
        FOR key IN keys ( %tky = key-%tky
                          LogObjectStatus = '02'
                          TransportRequest = lv_transport
                          %control-LogObjectStatus = if_abap_behv=>mk-on
                          %control-TransportRequest = if_abap_behv=>mk-on ) )
         FAILED   failed
         REPORTED reported.

  " Read changed data for action result
  READ ENTITIES OF zi_object IN LOCAL MODE
    ENTITY Subobject
      FROM VALUE #(
        FOR key IN keys (  %tky = key-%tky
                           %control = VALUE #(
                           Subobject = if_abap_behv=>mk-on
                           LogObjectStatus = if_abap_behv=>mk-on
                           SubobjectText = if_abap_behv=>mk-on
                           TransportRequest = if_abap_behv=>mk-on ) ) )
  RESULT DATA(lt_result).

  result = VALUE #( FOR subobject IN lt_result ( %tky = subobject-%tky
                                          %param    = subobject
                                            ) ).
ENDMETHOD.

METHOD ActivateObject1.

  DATA(lt_keys) = keys.

  READ ENTITIES OF zi_object IN LOCAL MODE
          ENTITY Subobject
            FIELDS ( Subobject
                     SubobjectText
                     ObjectUuid )
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
      DATA(ls_keys) = lt_keys[ %tky = ls_subobject-%tky ].
      DATA(lv_transport) = ls_keys-%param-transport_request.
      TRY.
          lo_log_object->add_subobject( EXPORTING iv_object = lt_objects[ %data-ObjectUuid = ls_subobject-%data-ObjectUuid ]-Object
                                                  iv_subobject = ls_subobject-Subobject
                                                  iv_subobject_text = ls_subobject-SubobjectText
                                                  iv_transport_request = lv_transport ).
        CATCH cx_bali_objects INTO DATA(lx_exception).
          "WRITE lx_exception->get_text( ).
      ENDTRY.
    ENDLOOP.
  ENDIF.
  MODIFY ENTITIES OF zi_object IN LOCAL MODE
    ENTITY Subobject
      UPDATE FROM VALUE #(
        FOR key IN keys ( %tky = key-%tky
                          LogObjectStatus = '01'
                          TransportRequest = lv_transport
                          %control-LogObjectStatus = if_abap_behv=>mk-on
                          %control-TransportRequest = if_abap_behv=>mk-on ) )
         FAILED   failed
         REPORTED reported.

  " Read changed data for action result
  READ ENTITIES OF zi_object IN LOCAL MODE
    ENTITY Subobject
      FROM VALUE #(
        FOR key IN keys (  %tky = key-%tky
                           %control = VALUE #(
                           Subobject = if_abap_behv=>mk-on
                           LogObjectStatus = if_abap_behv=>mk-on
                           SubobjectText = if_abap_behv=>mk-on
                           TransportRequest = if_abap_behv=>mk-on ) ) )
  RESULT DATA(lt_result).

  result = VALUE #( FOR subobject IN lt_result ( %tky = subobject-%tky
                                          %param    = subobject
                                            ) ).
ENDMETHOD.

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

*  METHOD AddSubobject.
*
*    READ ENTITIES OF zi_object IN LOCAL MODE
*            ENTITY Subobject
*              FIELDS ( Subobject
*                       SubobjectText
*                       TransportRequest )
*            WITH CORRESPONDING #( keys )
*          RESULT DATA(lt_subobject).
*
*    READ ENTITIES OF zi_object IN LOCAL MODE
*           ENTITY Subobject BY \_Object
*             FIELDS ( Object )
*         WITH CORRESPONDING #( keys )
*       RESULT DATA(lt_objects).
*
*    IF lt_subobject IS NOT INITIAL.
*      DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).
*
*      LOOP AT lt_subobject INTO DATA(ls_subobject).
*
*        TRY.
*            lo_log_object->add_subobject( EXPORTING iv_object = lt_objects[ %data-ObjectUuid = ls_subobject-%data-ObjectUuid ]-Object
*                                                    iv_subobject = ls_subobject-Subobject
*                                                    iv_subobject_text = ls_subobject-SubobjectText
*                                                    iv_transport_request = ls_subobject-TransportRequest ).
*          CATCH cx_bali_objects INTO DATA(lx_exception).
*            "WRITE lx_exception->get_text( ).
*        ENDTRY.
*      ENDLOOP.
*    ENDIF.
*  ENDMETHOD.

METHOD get_features.
  READ ENTITIES OF zi_object IN LOCAL MODE
    ENTITY Subobject
       FIELDS ( LogObjectStatus )
         WITH CORRESPONDING #( keys )
      RESULT    DATA(lt_subobject).
  IF lt_subobject IS NOT INITIAL.

    LOOP AT lt_subobject INTO DATA(ls_subobject).

      DATA ls_result LIKE LINE OF result.

      ls_result = VALUE #(
                                  %tky                   = ls_subobject-%tky

                                   %features-%action-ActivateObject1 = COND #( WHEN ls_subobject-LogObjectStatus = '01'
                                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                                   %features-%action-DeactivateObject1 = COND #( WHEN ls_subobject-LogObjectStatus = '02'
                                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                                   %features-%delete = COND #( WHEN ls_subobject-LogObjectStatus = '01'
                                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                                ).
      APPEND ls_result TO result.
    ENDLOOP.
  ENDIF.
ENDMETHOD.


ENDCLASS.
