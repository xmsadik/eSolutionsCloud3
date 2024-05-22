CLASS lhc_zetr_ddl_i_unit_codes DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_unit_codes RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_unit_codes IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_unit_codes DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_unit_codes IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_main TYPE TABLE OF zetr_t_units,
          lt_text TYPE TABLE OF zetr_t_unitx,
          lt_dele TYPE RANGE OF zetr_e_unitc.

    IF create-zetr_ddl_i_unit_codes IS NOT INITIAL.
      SELECT unitc
        FROM zetr_t_units
        FOR ALL ENTRIES IN @create-zetr_ddl_i_unit_codes
        WHERE unitc = @create-zetr_ddl_i_unit_codes-unitcode
        INTO TABLE @DATA(lt_existing_units).
      SORT lt_existing_units BY unitc.
    ENDIF.

    LOOP AT create-zetr_ddl_i_unit_codes INTO DATA(ls_create).
      IF line_exists( lt_existing_units[ unitc = ls_create-unitcode ] ).
        APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '200'
                                            severity = if_abap_behv_message=>severity-success
                                            v1       = ls_create-unitcode ) ) TO reported-zetr_ddl_i_unit_codes.
      ELSE.
        APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
        <ls_main>-unitc = ls_create-unitcode.

        APPEND INITIAL LINE TO lt_text ASSIGNING FIELD-SYMBOL(<ls_text>).
        <ls_text>-spras = sy-langu.
        <ls_text>-unitc = ls_create-unitcode.
        <ls_text>-bezei = ls_create-description.
      ENDIF.
    ENDLOOP.

    LOOP AT update-zetr_ddl_i_unit_codes INTO DATA(ls_update).
      APPEND INITIAL LINE TO lt_text ASSIGNING <ls_text>.
      <ls_text>-spras = sy-langu.
      <ls_text>-unitc = ls_update-unitcode.
      <ls_text>-bezei = ls_update-description.
    ENDLOOP.

    LOOP AT delete-zetr_ddl_i_unit_codes INTO DATA(ls_delete).
      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
      <ls_dele>-low = ls_delete-unitcode.
      <ls_dele>-sign = 'I'.
      <ls_dele>-option = 'EQ'.
    ENDLOOP.

    IF lt_dele IS NOT INITIAL.
      DELETE FROM zetr_t_units WHERE unitc IN @lt_dele.
      DELETE FROM zetr_t_unitx WHERE unitc IN @lt_dele.
    ENDIF.
    IF lt_main IS NOT INITIAL.
      INSERT zetr_t_units FROM TABLE @lt_main.
    ENDIF.
    IF lt_text IS NOT INITIAL.
      MODIFY zetr_t_unitx FROM TABLE @lt_text.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.