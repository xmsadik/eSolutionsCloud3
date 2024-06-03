  METHOD get_data_vbrk.
    SELECT SINGLE vbrk~BillingDocument AS vbeln,
                  vbrk~TransactionCurrency AS waerk,
                  vbrk~IncotermsClassification AS inco1,
                  ' ' AS exnum,
                  vbrk~CreationDate AS erdat,
                  vbrk~BillingDocumentDate AS fkdat,
                  vbrk~BillingDocumentDate AS netdt,
                  vbrk~BillingDocumentType AS fkart,
                  vbrk~CustomerPaymentTerms AS zterm,
                  vbrk~AccountingExchangeRate AS kurrf,
                  vbrk~ExchangeRateDate AS kurrf_dat,
                  vbrk~TotalNetAmount AS netwr,
                  vbpa~customer AS kunre,
                  vbpa~addressID AS adrre,
                  vbrk~PricingDocument AS knumv
      FROM I_BillingDocument AS vbrk
      LEFT OUTER JOIN I_BillingDocumentPartner AS vbpa
        ON  vbpa~billingdocument = vbrk~billingdocument
        AND vbpa~partnerfunction = 'RE'
      WHERE vbrk~BillingDocument = @ms_document-belnr
      INTO @ms_billing_data-vbrk.
    CHECK sy-subrc = 0.

    SELECT *
      FROM zetr_t_inv_cond
      INTO TABLE @ms_billing_data-conditions.

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
      INTO CORRESPONDING FIELDS OF @ms_billing_data-t001.

    SELECT vbrp~BillingDocumentItem AS posnr,
           vbrp~BillingQuantity AS fkimg,
           vbrp~BillingQuantityUnit AS vrkme,
           vbrp~Product AS matnr,
           vbrp~BillingDocumentItemText AS arktx,
           vbrp~Plant AS werks,
           marc~CountryOfOrigin AS herkl,
           t005t~countryname AS herkx,
           ' ' AS hscod,
           vbrp~ReferenceSDDocument AS vgbel,
           vbrp~ReferenceSDDocumentItem AS vgpos,
           likp~shippingtype AS vgvsa,
           likp~ReferenceDocumentNumber AS vgxbl,
           likp~DeliveryDocumentBySupplier AS vglfx,
           CASE WHEN likp~ActualGoodsMovementDate IS NOT INITIAL THEN likp~ActualGoodsMovementDate ELSE likp~PlannedGoodsIssueDate END AS vgdat,
           vbrp~SalesDocument AS aubel,
           vbrp~SalesDocumentItem AS aupos,
           vbak~salesdocumentdate AS audat,
           vbap~MaterialByCustomer AS aumat,
           ' ' AS aubst,
           vbap~ShippingType AS auvsa,
           CASE WHEN vbpa~customer <> ' ' THEN vbpa~customer ELSE @ms_billing_data-vbrk-kunre END AS kunwe,
           CASE WHEN vbpa~addressid <> ' ' THEN vbpa~addressid ELSE @ms_billing_data-vbrk-adrre END AS adrwe,
           vbrp~netamount AS netwr,
           vbrp~Subtotal1Amount AS kzwi1,
           vbrp~Subtotal2Amount AS kzwi2,
           vbrp~Subtotal3Amount AS kzwi3,
           vbrp~Subtotal4Amount AS kzwi4,
           vbrp~Subtotal5Amount AS kzwi5,
           vbrp~Subtotal6Amount AS kzwi6
      FROM i_billingdocumentitem AS vbrp
      LEFT OUTER JOIN I_ProductPlantBasic AS marc
        ON  marc~product = vbrp~product
        AND marc~plant = vbrp~plant
      LEFT OUTER JOIN I_CountryText AS t005t
        ON  t005t~Language = @sy-langu
        AND t005t~country = marc~CountryOfOrigin
      LEFT OUTER JOIN I_DeliveryDocument AS likp
        ON likp~deliverydocument = vbrp~ReferenceSDDocument
      LEFT OUTER JOIN I_SalesDocument AS vbak
        ON vbak~salesdocument = vbrp~SalesDocument
      LEFT OUTER JOIN i_salesdocumentitem AS vbap
        ON  vbap~salesdocument = vbrp~salesdocument
        AND vbap~salesdocumentitem = vbrp~salesdocumentitem
      LEFT OUTER JOIN I_SDDocumentItemPartner WITH PRIVILEGED ACCESS AS vbpa
        ON  vbpa~SDDocument = vbrp~billingdocument
        AND vbpa~sddocumentitem = vbrp~BillingDocumentItem
        AND vbpa~partnerfunction = 'WE'
      WHERE vbrp~BillingDocument = @ms_document-belnr
      INTO TABLE @ms_billing_data-vbrp.

    SELECT BillingDocumentItem AS kposn,
           PricingProcedureStep AS stunr,
           PricingProcedureCounter AS zaehk,
           ConditionType AS kschl,
           ConditionInactiveReason AS kinak,
           ConditionClass AS koaid,
           ConditionRateValue AS kbetr,
           ConditionAmount AS kwert,
           ConditionCurrency AS konwa,
           @ms_billing_data-vbrk-kurrf AS kkurs,
           ConditionQuantity AS kpein,
           ConditionQuantityUnit AS kmein,
           TaxCode AS mwsk1
      FROM I_BillingDocItemPrcgElmntBasic
      WHERE BillingDocument = @ms_document-belnr
      INTO TABLE @ms_billing_data-konv.

    SELECT SINGLE TaxNumber1 AS stcd1,
                  TaxNumber2 AS stcd2,
                  TaxNumber3 AS stcd3,
                  AddressID AS adrnr
      FROM I_Customer
      WHERE Customer = @ms_billing_data-vbrk-kunre
      INTO @DATA(ls_partner_data).
    ms_billing_data-taxid = COND #( WHEN ls_partner_data-stcd3 IS NOT INITIAL THEN ls_partner_data-stcd3 ELSE ls_partner_data-stcd2 ).
    ms_billing_data-tax_office = ls_partner_data-stcd1.
    ms_billing_data-address_number = ls_partner_data-adrnr.
  ENDMETHOD.