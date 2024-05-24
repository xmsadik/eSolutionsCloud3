  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_p_incoming_invoices.
    lt_output = CORRESPONDING #( it_original_data ).
    CHECK lt_output IS NOT INITIAL.

*    SELECT *
*      FROM ddcds_customer_domain_value_t( p_domain_name = 'ZETR_D_RESST' )
*      WHERE language = @sy-langu
*      INTO TABLE @DATA(lt_resst).
*    SORT lt_resst BY value_low.
*
*    SELECT *
*      FROM ddcds_customer_domain_value_t( p_domain_name = 'ZETR_D_LOGCD' )
*      WHERE language = @sy-langu
*      INTO TABLE @DATA(lt_logcd).
*    SORT lt_logcd BY value_low.
    TRY.
        SELECT head~CompanyCode, head~AccountingDocument, head~FiscalYear,
                head~DocumentReferenceID, head~ReferenceDocumentType, head~OriginalReferenceDocument,
                item~Customer, customer~businesspartner AS CustomerPartner, CustomerTaxNumber~bptaxnumber AS CustomerTaxNumber,
                item~Supplier, supplier~businesspartner AS SupplierPartner, supplierTaxNumber~bptaxnumber AS SupplierTaxNumber
           FROM i_journalentry AS head
           INNER JOIN i_journalentryitem AS item
             ON  item~CompanyCode = head~CompanyCode
             AND item~AccountingDocument = head~AccountingDocument
             AND item~FiscalYear = head~FiscalYear
           LEFT OUTER JOIN I_BusinessPartnerSupplier AS Supplier
             ON Supplier~Supplier = item~Supplier
           LEFT OUTER JOIN i_businesspartnertaxnumber AS SupplierTaxNumber
             ON SupplierTaxNumber~businesspartner = supplier~businesspartner
             AND ( SupplierTaxNumber~bptaxtype = 'TR2' OR SupplierTaxNumber~bptaxtype = 'TR3' )
           LEFT OUTER JOIN I_BusinessPartnerCustomer AS Customer
             ON Customer~Customer = item~Customer
           LEFT OUTER JOIN i_businesspartnertaxnumber AS CustomerTaxNumber
             ON CustomerTaxNumber~businesspartner = Customer~businesspartner
             AND ( CustomerTaxNumber~bptaxtype = 'TR2' OR CustomerTaxNumber~bptaxtype = 'TR3' )
           FOR ALL ENTRIES IN @lt_output
           WHERE head~DocumentReferenceID = @lt_output-InvoiceID
             AND head~IsReversal = ''
             AND head~IsReversed = ''
             AND item~ledger = '0L'
             AND item~financialaccounttype IN ('D','K')
           INTO TABLE @DATA(lt_accounting_documents).
        IF sy-subrc = 0.
          SORT lt_accounting_documents BY CompanyCode DocumentReferenceID SupplierTaxNumber CustomerTaxNumber.
          SELECT *
            FROM ddcds_customer_domain_value_t( p_domain_name = 'ZETR_D_AWTYP' )
            WHERE language = @sy-langu
            INTO TABLE @DATA(lt_awtyp).
          SORT lt_awtyp BY value_low.
        ENDIF.
        LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
          IF lt_accounting_documents IS NOT INITIAL.
            READ TABLE lt_accounting_documents
              INTO DATA(ls_accounting_document)
              WITH KEY CompanyCode = <ls_output>-CompanyCode
                       DocumentReferenceID = <ls_output>-InvoiceID
                       SupplierTaxNumber = <ls_output>-TaxID
              BINARY SEARCH.
            IF sy-subrc <> 0.
              READ TABLE lt_accounting_documents
                INTO ls_accounting_document
                WITH KEY CompanyCode = <ls_output>-CompanyCode
                         DocumentReferenceID = <ls_output>-InvoiceID
                         SupplierTaxNumber = ''
                         CustomerTaxNumber = <ls_output>-TaxID
                BINARY SEARCH.
            ENDIF.
            IF sy-subrc = 0.
              <ls_output>-ReferenceDocumentType = ls_accounting_document-ReferenceDocumentType(4).
              <ls_output>-ReferenceDocumentNumber = ls_accounting_document-OriginalReferenceDocument(10).
              <ls_output>-ReferenceDocumentYear = ls_accounting_document-FiscalYear.
            ENDIF.
          ENDIF.

          cl_system_uuid=>convert_uuid_c22_static(
            EXPORTING
              uuid = <ls_output>-DocumentUUID
            IMPORTING
              uuid_c36 = DATA(lv_uuid) ).

*          <ls_output>-PDFContentUrl = 'javascript:window.open("https://' && cl_abap_context_info=>get_system_url( ) &&
          <ls_output>-PDFContentUrl = 'https://' && zcl_etr_regulative_common=>get_ui_url( ) &&
                                      '/sap/opu/odata/sap/ZETR_DDL_D_INCOMING_INV/InvoiceContents(DocumentUUID=guid''' &&
                                      lv_uuid && ''',ContentType=''PDF'',DocumentType=''INCINVDOC'')/$value'.
*                                      lv_uuid && ''',ContentType=''PDF'')/$value")'.

*      <ls_output>-MimeType = 'application/pdf'.
*      <ls_output>-filename = 'PDF'.
*      IF lines( it_original_data ) = 1.
*        SELECT SINGLE contn
*          FROM zetr_t_arcd
*          WHERE docui = @<ls_output>-DocumentUUID
*            AND conty = 'PDF'
*          INTO @<ls_output>-PDFContent.
*        IF <ls_output>-PDFContent IS INITIAL.
*          TRY.
*              DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( <ls_output>-companycode ).
*              <ls_output>-PDFContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = <ls_output>-DocumentUUID
*                                                                                          iv_content_type = 'PDF' ).
**                                                                                          iv_create_log = abap_false ).
*            CATCH zcx_etr_regulative_exception.
*          ENDTRY.
*        ENDIF.
*      ENDIF.

*      IF <ls_output>-Archived = abap_true.
*        READ TABLE lt_logcd
*          INTO DATA(ls_logcd)
*          WITH KEY value_low = zcl_etr_regulative_log=>mc_log_codes-archived
*          BINARY SEARCH.
*        IF sy-subrc = 0.
*          <ls_output>-OverallStatus = ls_logcd-text.
*        ENDIF.
*      ENDIF.
*
*      IF <ls_output>-Processed = abap_true.
*        READ TABLE lt_logcd
*          INTO ls_logcd
*          WITH KEY value_low = zcl_etr_regulative_log=>mc_log_codes-processed
*          BINARY SEARCH.
*        IF sy-subrc = 0.
*          <ls_output>-OverallStatus = COND #( WHEN <ls_output>-OverallStatus IS INITIAL
*                                                   THEN ls_logcd-text
*                                                   ELSE <ls_output>-OverallStatus && ` - ` && ls_logcd-text ).
*        ENDIF.
*      ELSEIF <ls_output>-ResponseStatus <> '2' AND <ls_output>-ResponseStatus <> 'X'.
*        READ TABLE lt_resst
*          INTO DATA(ls_resst)
*          WITH KEY value_low = <ls_output>-ResponseStatus
*          BINARY SEARCH.
*        IF sy-subrc = 0.
*          <ls_output>-OverallStatus = COND #( WHEN <ls_output>-OverallStatus IS INITIAL
*                                                   THEN ls_resst-text
*                                                   ELSE <ls_output>-OverallStatus && ` - ` && ls_resst-text ).
*        ENDIF.
*      ELSE.
*        READ TABLE lt_logcd
*          INTO ls_logcd
*          WITH KEY value_low = zcl_etr_regulative_log=>mc_log_codes-ready
*          BINARY SEARCH.
*        IF sy-subrc = 0.
*          <ls_output>-OverallStatus = COND #( WHEN <ls_output>-OverallStatus IS INITIAL
*                                                   THEN ls_logcd-text
*                                                   ELSE <ls_output>-OverallStatus && ` - ` && ls_logcd-text ).
*        ENDIF.
*
*        READ TABLE lt_resst
*          INTO ls_resst
*          WITH KEY value_low = <ls_output>-ResponseStatus
*          BINARY SEARCH.
*        IF sy-subrc = 0.
*          <ls_output>-OverallStatus = COND #( WHEN <ls_output>-OverallStatus IS INITIAL
*                                                   THEN ls_resst-text
*                                                   ELSE <ls_output>-OverallStatus && ` - ` && ls_resst-text ).
*        ENDIF.
*      ENDIF.
*
*      IF <ls_output>-ReferenceDocumentNumber IS NOT INITIAL.
*        READ TABLE lt_awtyp
*          INTO DATA(ls_awtyp)
*          WITH KEY value_low = <ls_output>-ReferenceDocumentType(4)
*          BINARY SEARCH.
*        READ TABLE lt_logcd
*          INTO ls_logcd
*          WITH KEY value_low = zcl_etr_regulative_log=>mc_log_codes-created
*          BINARY SEARCH.
*        <ls_output>-OverallStatus = <ls_output>-OverallStatus && ` (` &&
*                                    ls_awtyp-text && ` ` &&
*                                    <ls_output>-ReferenceDocumentNumber && ` ` &&
*                                    ls_logcd-text && `)`.
*      ENDIF.

*      IF <ls_output>-ResponseStatus <> '0'.
*        <ls_output>-OverallRating += 1.
*      ENDIF.
*      IF <ls_output>-ReferenceDocumentNumber IS NOT INITIAL.
*        <ls_output>-OverallRating += 1.
*      ENDIF.
*      IF <ls_output>-Processed = abap_true.
*        <ls_output>-OverallRating += 1.
*      ENDIF.
        ENDLOOP.

      CATCH cx_root INTO DATA(lx_root).

    ENDTRY.

    ct_calculated_data = CORRESPONDING #( lt_output ).
    DATA(lv_subrc) = sy-sysid.
  ENDMETHOD.