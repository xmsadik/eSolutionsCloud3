*CLASS lsc_zetr_ddl_i_invoice_param DEFINITION INHERITING FROM cl_abap_behavior_saver.
*
*  PROTECTED SECTION.
*
*    METHODS save_modified REDEFINITION.
*
*ENDCLASS.
*
*CLASS lsc_zetr_ddl_i_invoice_param IMPLEMENTATION.
*
*  METHOD save_modified.
*    DATA: lt_main TYPE TABLE OF zetr_t_inv_rules,
*          lt_dele TYPE TABLE OF zetr_t_inv_rules.
*
*    SELECT bukrs, MAX( rulen ) AS rulen
*      FROM zetr_t_inv_rules
*      WHERE rulet = 'P'
*        AND pidin = ''
*      GROUP BY bukrs
*      INTO TABLE @DATA(lt_item_numbers).
*    SORT lt_item_numbers BY bukrs.
*
*    IF update-zetr_ddl_i_inv_scenario_rules IS NOT INITIAL.
*      SELECT *
*        FROM zetr_ddl_i_inv_scenario_rules
*        FOR ALL ENTRIES IN @update-zetr_ddl_i_inv_scenario_rules
*        WHERE companycode = @update-zetr_ddl_i_inv_scenario_rules-companycode
*          AND ruletype = @update-zetr_ddl_i_inv_scenario_rules-ruletype
*          AND ruleitemnumber = @update-zetr_ddl_i_inv_scenario_rules-ruleitemnumber
*        INTO TABLE @DATA(lt_existing_codes).
*    ENDIF.
*    SORT lt_existing_codes BY ruleitemnumber.
*
*    LOOP AT create-zetr_ddl_i_inv_scenario_rules INTO DATA(ls_create).
*      READ TABLE lt_item_numbers ASSIGNING FIELD-SYMBOL(<ls_item_number>) WITH KEY bukrs = ls_create-companycode BINARY SEARCH.
*      IF sy-subrc <> 0.
*        APPEND INITIAL LINE TO lt_item_numbers ASSIGNING <ls_item_number>.
*        <ls_item_number>-bukrs = ls_create-companycode.
*      ENDIF.
*      <ls_item_number>-rulen += 1.
*      APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
*      <ls_main>-bukrs   = ls_create-companycode.
*      <ls_main>-rulet   = 'P'.
*      <ls_main>-rulen   = <ls_item_number>-rulen.
*      <ls_main>-awtyp   = ls_create-referencedocumenttype.
*      <ls_main>-vkorg   = ls_create-salesorganization.
*      <ls_main>-vtweg   = ls_create-distributionchannel.
*      <ls_main>-werks   = ls_create-plant.
*      <ls_main>-pidin   = ''.
*      <ls_main>-ityin   = ''.
*      <ls_main>-sddty   = ls_create-billingdocumenttype.
*      <ls_main>-mmdty   = ls_create-invoicereceipttype.
*      <ls_main>-fidty   = ls_create-accountingdocumenttype.
*      <ls_main>-partner = ls_create-partner.
*      <ls_main>-vbeln   = ''.
*      <ls_main>-serpr   = ''.
*      <ls_main>-xsltt   = ''.
*      <ls_main>-pidou   = ls_create-profileid.
*      <ls_main>-ityou   = ls_create-invoicetype.
*      <ls_main>-taxex   = ls_create-taxexemption.
*      <ls_main>-note    = ''.
*    ENDLOOP.
*
*    LOOP AT update-zetr_ddl_i_inv_scenario_rules INTO DATA(ls_update).
*      READ TABLE lt_existing_codes INTO DATA(ls_existing_code) WITH KEY ruleitemnumber = ls_update-ruleitemnumber BINARY SEARCH.
*      CHECK sy-subrc = 0.
*
*      IF ls_update-%control-accountingdocumenttype = if_abap_behv=>mk-on OR
*         ls_update-%control-billingdocumenttype = if_abap_behv=>mk-on OR
*         ls_update-%control-distributionchannel = if_abap_behv=>mk-on OR
*         ls_update-%control-invoicereceipttype = if_abap_behv=>mk-on OR
*         ls_update-%control-invoicetype = if_abap_behv=>mk-on OR
*         ls_update-%control-partner = if_abap_behv=>mk-on OR
*         ls_update-%control-plant = if_abap_behv=>mk-on OR
*         ls_update-%control-profileid = if_abap_behv=>mk-on OR
*         ls_update-%control-referencedocumenttype = if_abap_behv=>mk-on OR
*         ls_update-%control-salesorganization = if_abap_behv=>mk-on OR
*         ls_update-%control-taxexemption = if_abap_behv=>mk-on.
*        APPEND INITIAL LINE TO lt_main ASSIGNING <ls_main>.
*        <ls_main>-bukrs = ls_update-companycode.
*        <ls_main>-rulet = ls_update-ruletype.
*        <ls_main>-rulen = ls_update-ruleitemnumber.
*        CASE ls_update-%control-accountingdocumenttype.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-fidty = ls_update-accountingdocumenttype.
*          WHEN OTHERS.
*            <ls_main>-fidty = ls_existing_code-accountingdocumenttype.
*        ENDCASE.
*        CASE ls_update-%control-billingdocumenttype.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-sddty = ls_update-billingdocumenttype.
*          WHEN OTHERS.
*            <ls_main>-sddty = ls_existing_code-billingdocumenttype.
*        ENDCASE.
*        CASE ls_update-%control-distributionchannel.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-vtweg = ls_update-distributionchannel.
*          WHEN OTHERS.
*            <ls_main>-vtweg = ls_existing_code-distributionchannel.
*        ENDCASE.
*        CASE ls_update-%control-invoicereceipttype.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-mmdty = ls_update-invoicereceipttype.
*          WHEN OTHERS.
*            <ls_main>-mmdty = ls_existing_code-invoicereceipttype.
*        ENDCASE.
*        CASE ls_update-%control-invoicetype.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-ityou = ls_update-invoicetype.
*          WHEN OTHERS.
*            <ls_main>-ityou = ls_existing_code-invoicetype.
*        ENDCASE.
*        CASE ls_update-%control-partner.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-partner = ls_update-partner.
*          WHEN OTHERS.
*            <ls_main>-partner = ls_existing_code-partner.
*        ENDCASE.
*        CASE ls_update-%control-plant.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-werks = ls_update-plant.
*          WHEN OTHERS.
*            <ls_main>-werks = ls_existing_code-plant.
*        ENDCASE.
*        CASE ls_update-%control-profileid.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-pidou = ls_update-profileid.
*          WHEN OTHERS.
*            <ls_main>-pidou = ls_existing_code-profileid.
*        ENDCASE.
*        CASE ls_update-%control-referencedocumenttype.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-awtyp = ls_update-referencedocumenttype.
*          WHEN OTHERS.
*            <ls_main>-awtyp = ls_existing_code-referencedocumenttype.
*        ENDCASE.
*        CASE ls_update-%control-salesorganization.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-vkorg = ls_update-salesorganization.
*          WHEN OTHERS.
*            <ls_main>-vkorg = ls_existing_code-salesorganization.
*        ENDCASE.
*        CASE ls_update-%control-taxexemption.
*          WHEN if_abap_behv=>mk-on.
*            <ls_main>-taxex = ls_update-taxexemption.
*          WHEN OTHERS.
*            <ls_main>-taxex = ls_existing_code-taxexemption.
*        ENDCASE.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT delete-zetr_ddl_i_inv_scenario_rules INTO DATA(ls_delete).
*      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
*      <ls_dele>-bukrs = ls_delete-companycode.
*      <ls_dele>-rulet = ls_delete-ruletype.
*      <ls_dele>-rulen = ls_delete-ruleitemnumber.
*    ENDLOOP.
*
*    IF lt_dele IS NOT INITIAL.
*      DELETE zetr_t_inv_rules FROM TABLE @lt_dele.
*    ENDIF.
*    IF lt_main IS NOT INITIAL.
*      MODIFY zetr_t_inv_rules FROM TABLE @lt_main.
*    ENDIF.
*  ENDMETHOD.
*
*ENDCLASS.

CLASS lhc_zetr_ddl_i_invoice_paramet DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_invoice_parameters RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_invoice_paramet IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.