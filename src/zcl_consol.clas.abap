CLASS zcl_consol DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_consol IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TYPES:
      tv_description TYPE  if_xco_aplo_content=>tv_description,
      tv_object type sxco_aplo_object_name,

      BEGIN OF ts_content,
        object type tv_object,
        object_text TYPE tv_description,
      END OF ts_content.

    DATA ls_vh_object TYPE zce_object_vh.
    DATA lt_vh_object TYPE TABLE OF zce_object_vh.
    DATA ls_object_text TYPE ts_content.
    DATA lt_object_text TYPE TABLE OF ts_content.

*    DATA(lo_software_component_filter) = xco_cp_system=>software_component->get_filter(
*     xco_cp_abap_sql=>constraint->equal( 'ZLOCAL' ) ).
*
*    DATA(lo_name_filter) = xco_cp_abap_repository=>object_type->get_filter(
*    xco_cp_abap_sql=>constraint->contains_pattern( 'APLO' ) ).

*    DATA(lt_objects) = xco_cp_abap_repository=>objects->where( VALUE #(
*    ( lo_software_component_filter )
*    ( lo_name_filter )
*  ) )->in( xco_cp_abap=>repository )->get( ).

    DATA(lt_objects) = xco_cp_abap_repository=>objects->aplo->all->in( xco_cp_abap=>repository )->get(  ).
    LOOP AT lt_objects INTO DATA(ls_objects).
    DATA(lv_object) = ls_objects->name.
    DATA(lv_object_text) = ls_objects->content(  )->get_description(  ).
      ls_object_text-object = lv_object.
      ls_object_text-object_text = lv_object_text.
      APPEND ls_object_text  TO lt_object_text.

    ENDLOOP.

    SELECT distinct *
    FROM zi_vh_object
    INTO TABLE @DATA(lt_vh).

    LOOP AT lt_vh INTO DATA(ls_vh).
    data(lv_text) = lt_object_text[ object = ls_vh-ABAPObject ]-object_text.
    ls_vh_object-object_text = lv_text.
    ls_vh_object-object = ls_vh-ABAPObject.
    ls_vh_object-package_obj = ls_vh-ABAPPackage.
    append ls_vh_object to lt_vh_object.
    ENDLOOP.



    out->write(  lt_vh_object ).
  ENDMETHOD.
ENDCLASS.

