  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_p_outgoing_invoices.
    lt_output = CORRESPONDING #( it_original_data ).
    CHECK lt_output IS NOT INITIAL.

    LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
      <ls_output>-DocumentDisplayURL = 'https://' && zcl_etr_regulative_common=>get_ui_url( ) && '/ui#'.
      CASE <ls_output>-DocumentType(4).
        WHEN 'LIKP'.
          <ls_output>-DocumentDisplayURL = <ls_output>-DocumentDisplayURL &&
                                           'BillingDocument-displayBillingDocument?BillingDocument=' && <ls_output>-DocumentNumber.
        WHEN 'MKPF'.
          <ls_output>-DocumentDisplayURL = <ls_output>-DocumentDisplayURL &&
                                           'SupplierInvoice-displayAdvanced?SupplierInvoice=' && <ls_output>-DocumentNumber &&
                                           '&FiscalYear=' && <ls_output>-FiscalYear.
        WHEN 'BKPF'.
          <ls_output>-DocumentDisplayURL = <ls_output>-DocumentDisplayURL &&
                                           'GLAccount-displayGLLineItemReportingView?AccountingDocument=' && <ls_output>-DocumentNumber &&
                                           '&CompanyCode=' && <ls_output>-CompanyCode &&
                                           '&FiscalYear=' && <ls_output>-FiscalYear.
      ENDCASE.

*      IF <ls_output>-StatusCode <> '2' AND <ls_output>-StatusCode <> ''.
      TRY.
          cl_system_uuid=>convert_uuid_c22_static(
            EXPORTING
              uuid = <ls_output>-documentuuid
            IMPORTING
              uuid_c36 = DATA(lv_uuid) ).
        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.
      IF <ls_output>-StatusCode <> '2' AND <ls_output>-StatusCode <> ''.
        <ls_output>-ContentUrl = 'https://' && zcl_etr_regulative_common=>get_ui_url( ) &&
                                    '/sap/opu/odata/sap/ZETR_DDL_B_OUTG_INVOICES/Contents(DocumentUUID=guid''' &&
                                    lv_uuid && ''',ContentType=''PDF'',DocumentType=''OUTINVDOC'')/$value'.
*                                      lv_uuid && ''',ContentType=''PDF'')/$value")'.
      ELSE.
        <ls_output>-ContentUrl = 'https://' && zcl_etr_regulative_common=>get_ui_url( ) &&
                                    '/sap/opu/odata/sap/ZETR_DDL_B_OUTG_INVOICES/Contents(DocumentUUID=guid''' &&
                                    lv_uuid && ''',ContentType=''HTML'',DocumentType=''OUTINVDOC'')/$value'.
*                                      lv_uuid && ''',ContentType=''PDF'')/$value")'.
      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_output ).
  ENDMETHOD.