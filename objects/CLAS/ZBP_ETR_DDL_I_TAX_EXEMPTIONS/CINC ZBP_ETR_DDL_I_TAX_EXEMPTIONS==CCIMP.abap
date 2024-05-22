CLASS lhc_zetr_ddl_i_tax_exemptions DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_tax_exemptions RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_tax_exemptions IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_tax_exemptions DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_tax_exemptions IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_main TYPE TABLE OF zetr_t_taxex,
          lt_text TYPE TABLE OF zetr_t_taxed,
          lt_dele TYPE RANGE OF zetr_e_taxex.

    IF create-zetr_ddl_i_tax_exemptions IS NOT INITIAL.
      SELECT *
        FROM zetr_ddl_i_tax_exemptions
        FOR ALL ENTRIES IN @create-zetr_ddl_i_tax_exemptions
        WHERE exemptioncode = @create-zetr_ddl_i_tax_exemptions-exemptioncode
        INTO TABLE @DATA(lt_existing_codes).
    ENDIF.
    SORT lt_existing_codes BY exemptioncode.

    LOOP AT create-zetr_ddl_i_tax_exemptions INTO DATA(ls_create).
      IF line_exists( lt_existing_codes[ exemptioncode = ls_create-exemptioncode ] ).
        APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '200'
                                            severity = if_abap_behv_message=>severity-success
                                            v1       = ls_create-exemptioncode ) ) TO reported-zetr_ddl_i_tax_exemptions.
      ELSE.
        APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
        <ls_main>-taxex = ls_create-exemptioncode.
        <ls_main>-taxet = ls_create-exemptiontype.

        APPEND INITIAL LINE TO lt_text ASSIGNING FIELD-SYMBOL(<ls_text>).
        <ls_text>-spras = sy-langu.
        <ls_text>-taxex = ls_create-exemptioncode.
        <ls_text>-bezei = ls_create-description.
      ENDIF.
    ENDLOOP.

    LOOP AT update-zetr_ddl_i_tax_exemptions INTO DATA(ls_update).
      IF ls_update-%control-exemptiontype = if_abap_behv=>mk-on.
        APPEND INITIAL LINE TO lt_main ASSIGNING <ls_main>.
        <ls_main>-taxex = ls_update-exemptioncode.
        <ls_main>-taxet = ls_update-exemptiontype.
      ENDIF.

      IF ls_update-%control-description = if_abap_behv=>mk-on.
        APPEND INITIAL LINE TO lt_text ASSIGNING <ls_text>.
        <ls_text>-spras = sy-langu.
        <ls_text>-taxex = ls_update-exemptioncode.
        <ls_text>-bezei = ls_update-description.
      ENDIF.
    ENDLOOP.

    LOOP AT delete-zetr_ddl_i_tax_exemptions INTO DATA(ls_delete).
      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
      <ls_dele>-low = ls_delete-exemptioncode.
      <ls_dele>-sign = 'I'.
      <ls_dele>-option = 'EQ'.
    ENDLOOP.

    IF lt_dele IS NOT INITIAL.
      DELETE FROM zetr_t_taxex WHERE taxex IN @lt_dele.
      DELETE FROM zetr_t_taxed WHERE taxex IN @lt_dele.
    ENDIF.
    IF lt_main IS NOT INITIAL.
      MODIFY zetr_t_taxex FROM TABLE @lt_main.
    ENDIF.
    IF lt_text IS NOT INITIAL.
      MODIFY zetr_t_taxed FROM TABLE @lt_text.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.