  METHOD select_incinv_list.
    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lv_top) = lo_paging->get_page_size( ).
    DATA(lv_skip) = lo_paging->get_offset( ).
    DATA(lt_sort) = io_request->get_sort_elements( ).
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_list.
    DATA(lv_orderby_string) = VALUE string( ).

    IF lt_sort IS NOT INITIAL.
      CLEAR lv_orderby_string.
      LOOP AT lt_sort INTO DATA(ls_sort).
        IF ls_sort-descending = abap_true.
          CONCATENATE lv_orderby_string ls_sort-element_name 'DESCENDING' INTO lv_orderby_string SEPARATED BY space.
        ELSE.
          CONCATENATE lv_orderby_string ls_sort-element_name 'ASCENDING' INTO lv_orderby_string SEPARATED BY space.
        ENDIF.
      ENDLOOP.
    ELSE.
      lv_orderby_string = 'DOCUMENTUUID'.
    ENDIF.

    DATA(lv_where_clause) =  io_request->get_filter( )->get_as_sql_string( ).
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    SELECT *
      FROM zetr_ddl_i_incoming_invoices
      WHERE (lv_where_clause)
      ORDER BY (lv_orderby_string)
      INTO CORRESPONDING FIELDS OF TABLE @lt_output
      UP TO @lv_top ROWS
      OFFSET @lv_skip .
    IF sy-subrc = 0.
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
        LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
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
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.