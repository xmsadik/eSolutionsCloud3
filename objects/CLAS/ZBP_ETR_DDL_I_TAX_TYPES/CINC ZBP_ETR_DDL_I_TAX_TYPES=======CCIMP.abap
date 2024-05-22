CLASS lhc_zetr_ddl_i_tax_types DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_tax_types RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_tax_types IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_tax_types DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_tax_types IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_main TYPE TABLE OF zetr_t_taxcd,
          lt_text TYPE TABLE OF zetr_t_taxcx,
          lt_dele TYPE RANGE OF zetr_e_taxty.
    IF create-zetr_ddl_i_tax_types IS NOT INITIAL.
      SELECT *
        FROM zetr_ddl_i_tax_types
        FOR ALL ENTRIES IN @create-zetr_ddl_i_tax_types
        WHERE taxtype = @create-zetr_ddl_i_tax_types-taxtype
        INTO TABLE @DATA(lt_existing_codes).
    ENDIF.

    IF update-zetr_ddl_i_tax_types IS NOT INITIAL.
      SELECT *
        FROM zetr_ddl_i_tax_types
        FOR ALL ENTRIES IN @update-zetr_ddl_i_tax_types
        WHERE taxtype = @update-zetr_ddl_i_tax_types-taxtype
        APPENDING TABLE @lt_existing_codes.
    ENDIF.
    SORT lt_existing_codes BY taxtype.

    LOOP AT create-zetr_ddl_i_tax_types INTO DATA(ls_create).
      IF line_exists( lt_existing_codes[ taxtype = ls_create-taxtype ] ).
        APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '200'
                                            severity = if_abap_behv_message=>severity-success
                                            v1       = ls_create-taxtype ) ) TO reported-zetr_ddl_i_tax_types.
      ELSE.
        APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
        <ls_main>-taxty = ls_create-taxtype.
        <ls_main>-taxct = ls_create-taxcategory.

        APPEND INITIAL LINE TO lt_text ASSIGNING FIELD-SYMBOL(<ls_text>).
        <ls_text>-spras = sy-langu.
        <ls_text>-taxty = ls_create-taxtype.
        <ls_text>-stext = ls_create-shortdescription.
        <ls_text>-ltext = ls_create-longdescription.
      ENDIF.
    ENDLOOP.

    LOOP AT update-zetr_ddl_i_tax_types INTO DATA(ls_update).
      READ TABLE lt_existing_codes INTO DATA(ls_existing_code) WITH KEY taxtype = ls_update-taxtype BINARY SEARCH.
      CHECK sy-subrc = 0.
      IF ls_update-%control-taxcategory = if_abap_behv=>mk-on.
        APPEND INITIAL LINE TO lt_main ASSIGNING <ls_main>.
        <ls_main>-taxty = ls_update-taxtype.
        <ls_main>-taxct = ls_update-taxcategory.
      ENDIF.

      IF ls_update-%control-shortdescription = if_abap_behv=>mk-on OR ls_update-%control-longdescription = if_abap_behv=>mk-on.
        APPEND INITIAL LINE TO lt_text ASSIGNING <ls_text>.
        <ls_text>-spras = sy-langu.
        <ls_text>-taxty = ls_update-taxtype.
        CASE ls_update-%control-shortdescription.
          WHEN if_abap_behv=>mk-on.
            <ls_text>-stext = ls_update-shortdescription.
          WHEN OTHERS.
            <ls_text>-stext = ls_existing_code-shortdescription.
        ENDCASE.
        CASE ls_update-%control-longdescription.
          WHEN if_abap_behv=>mk-on.
            <ls_text>-ltext = ls_update-longdescription.
          WHEN OTHERS.
            <ls_text>-ltext = ls_existing_code-longdescription.
        ENDCASE.
      ENDIF.
    ENDLOOP.

    LOOP AT delete-zetr_ddl_i_tax_types INTO DATA(ls_delete).
      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
      <ls_dele>-low = ls_delete-taxtype.
      <ls_dele>-sign = 'I'.
      <ls_dele>-option = 'EQ'.
    ENDLOOP.

    IF lt_dele IS NOT INITIAL.
      DELETE FROM zetr_t_taxcd WHERE taxty IN @lt_dele.
      DELETE FROM zetr_t_taxcx WHERE taxty IN @lt_dele.
    ENDIF.
    IF lt_main IS NOT INITIAL.
      MODIFY zetr_t_taxcd FROM TABLE @lt_main.
    ENDIF.
    IF lt_text IS NOT INITIAL.
      MODIFY zetr_t_taxcx FROM TABLE @lt_text.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.