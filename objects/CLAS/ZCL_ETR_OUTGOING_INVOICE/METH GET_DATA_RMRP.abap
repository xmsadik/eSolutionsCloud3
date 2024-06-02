  METHOD get_data_rmrp.
    SELECT SINGLE SupplierInvoice AS document_number,
                  FiscalYear AS fiscal_year,
                  DocumentDate AS doc_date,
                  AccountingDocumentType AS doc_type,
                  DocumentCurrency AS Currency,
                  ExchangeRate AS exch_rate,
                  InvoiceGrossAmount AS gross_amnt,
                  InvoicingParty AS diff_inv
      FROM I_SupplierInvoiceAPI01
      WHERE SupplierInvoice = @ms_document-belnr
        AND FiscalYear = @ms_document-gjahr
      INTO @ms_invrec_data-headerdata.

    SELECT SupplierInvoiceItem AS invoice_doc_item,
           PurchaseOrder AS po_number,
           PurchaseOrderItem AS po_item,
           SupplierInvoiceItemText AS item_text,
           QuantityInPurchaseOrderUnit AS Quantity,
           PurchaseOrderPriceUnit AS po_unit,
           SupplierInvoiceItemAmount AS item_amount,
           TaxCode AS Tax_Code
      FROM I_SuplrInvcItemPurOrdRefAPI01
      WHERE SupplierInvoice = @ms_document-belnr
        AND FiscalYear = @ms_document-gjahr
      INTO TABLE @ms_invrec_data-itemdata.

    SELECT SupplierInvoiceItem AS invoice_doc_item,
           SupplierInvoiceItemText AS item_text,
           SupplierInvoiceItemAmount AS item_amount,
           TaxCode AS Tax_Code
      FROM I_SuplrInvoiceItemGLAcctAPI01
      WHERE SupplierInvoice = @ms_document-belnr
        AND FiscalYear = @ms_document-gjahr
      INTO TABLE @ms_invrec_data-glaccountdata.

    SELECT SINGLE company~companycode AS bukrs,
                  company~currency AS waers,
                  company~country AS land1,
                  CASE WHEN company~CountryChartOfAccounts IS NOT INITIAL THEN CountryChartOfAccounts
                  ELSE company~chartofaccounts END AS ktopl,
                  country~taxcalculationprocedure AS kalsm
      FROM I_CompanyCode AS company
      INNER JOIN i_country AS country
        ON country~country = company~country
      WHERE companycode = @ms_document-bukrs
      INTO CORRESPONDING FIELDS OF @ms_invrec_data-t001.

    SELECT country AS land1, CountryName AS landx
      FROM I_CountryText
      WHERE Language = @sy-langu
        AND Country = @ms_invrec_data-t001-land1
      INTO TABLE @ms_invrec_data-t005.

    SELECT SINGLE TaxNumber1 AS stcd1,
                  TaxNumber2 AS stcd2,
                  TaxNumber3 AS stcd3,
                  AddressID AS adrnr
      FROM I_Supplier
      WHERE Supplier = @ms_invrec_data-headerdata-diff_inv
      INTO @DATA(ls_partner_data).
    ms_invrec_data-taxid = COND #( WHEN ls_partner_data-stcd3 IS NOT INITIAL THEN ls_partner_data-stcd3 ELSE ls_partner_data-stcd2 ).
    ms_invrec_data-tax_office = ls_partner_data-stcd1.
    ms_invrec_data-address_number = ls_partner_data-adrnr.

    IF ms_invrec_data-itemdata IS NOT INITIAL.
      SELECT PurchaseOrder AS ebeln,
             PurchaseOrderItem AS ebelp,
             material AS matnr,
             ProductName AS maktx,
             PurchaseOrderItemText AS txz01
        FROM I_PurchaseOrderItemAPI01 AS item
          LEFT OUTER JOIN I_ProductText AS ProductText
            ON  ProductText~Language = @sy-langu
            AND ProductText~Product = item~material
        FOR ALL ENTRIES IN @ms_invrec_data-itemdata
        WHERE PurchaseOrder = @ms_invrec_data-itemdata-po_number
          AND PurchaseOrderItem = @ms_invrec_data-itemdata-po_item
        INTO TABLE @ms_invrec_data-ekpo.
      IF sy-subrc IS INITIAL.
        SELECT PurchaseOrder AS ebeln,
               PurchaseOrderItem AS ebelp,
               AccountAssignmentNumber AS zekkn,
               PurchasingHistoryDocumentType AS vgabe,
               PurchasingHistoryDocumentYear AS gjahr,
               PurchasingHistoryDocument AS belnr,
               PurchasingHistoryDocumentItem AS buzei,
               PostingDate AS budat,
               Quantity AS menge,
               DocumentReferenceID AS xblnr
          FROM I_PurchaseOrderHistoryAPI01
          FOR ALL ENTRIES IN @ms_invrec_data-ekpo
          WHERE PurchaseOrder = @ms_invrec_data-ekpo-ebeln
            AND PurchaseOrderItem = @ms_invrec_data-ekpo-ebelp
          INTO TABLE @ms_invrec_data-ekbe.
*        IF sy-subrc IS INITIAL.
*          SELECT *
*            FROM mseg
*            INTO TABLE rs_data-mseg
*            FOR ALL ENTRIES IN rs_data-ekbe
*            WHERE mblnr = rs_data-ekbe-belnr
*              AND mjahr = rs_data-ekbe-gjahr
*              AND zeile = rs_data-ekbe-buzei
*              AND NOT EXISTS ( SELECT * FROM mseg WHERE smbln = mseg~mblnr AND sjahr = mseg~mjahr AND smblp = mseg~zeile ).
*        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.