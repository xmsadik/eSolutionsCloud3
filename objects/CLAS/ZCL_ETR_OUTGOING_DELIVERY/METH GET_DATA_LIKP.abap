  METHOD get_data_likp.
    SELECT SINGLE deliverydocument AS vbeln,
                  deliverydocumenttype AS lfart
      FROM I_DeliveryDocument
      WHERE deliverydocument = @ms_document-belnr
      INTO @ms_outdel_data-likp.
    CHECK sy-subrc = 0.

    SELECT lips~DeliveryDocument AS vbeln,
           lips~DeliveryDocumentItem AS posnr,
           lips~ActualDeliveryQuantity AS lfimg,
           lips~DeliveryQuantityUnit AS vrkme,
           lips~DeliveryDocumentItemText AS arktx,
           lips~Material AS matnr,
           lips~ReferenceSDDocument AS vgbel,
           lips~ReferenceSDDocumentItem AS vgpos,
           vbap~MaterialByCustomer AS kdmat
       FROM i_deliverydocumentitem AS lips
       LEFT OUTER JOIN i_salesdocumentitem AS vbap
        ON  vbap~salesdocument = lips~ReferenceSDDocument
        AND vbap~salesdocumentitem = lips~ReferenceSDDocumentItem
      WHERE DeliveryDocument = @ms_document-belnr
      INTO TABLE @ms_outdel_data-lips.

    SELECT SDDocument AS vbeln,
           PartnerFunction AS parvw,
           AddressID AS adrnr,
           Customer AS kunnr
      FROM I_SDDocumentPartner WITH PRIVILEGED ACCESS AS vbpa
      WHERE SDDocument = @ms_document-belnr
      INTO TABLE @ms_outdel_data-vbpa.

    SELECT SalesDocument AS vbeln, SalesDocumentDate AS audat
      FROM i_salesdocument
      FOR ALL ENTRIES IN @ms_outdel_data-lips
      WHERE salesdocument = @ms_outdel_data-lips-vgbel
      INTO TABLE @ms_outdel_data-vbak.

    SELECT SINGLE companycode AS bukrs,
                  currency AS waers,
                  country AS land1,
                  CASE WHEN CountryChartOfAccounts IS NOT INITIAL THEN CountryChartOfAccounts
                  ELSE chartofaccounts END AS ktopl
      FROM I_CompanyCode
      WHERE companycode = @ms_document-bukrs
      INTO CORRESPONDING FIELDS OF @ms_outdel_data-t001.

    READ TABLE ms_outdel_data-vbpa INTO DATA(ls_vbpa) WITH TABLE KEY by_parvw COMPONENTS Parvw = 'AG'.
    IF sy-subrc = 0.
      ms_outdel_data-address_number = ls_vbpa-adrnr.
      SELECT SINGLE TaxNumber1 AS stcd1,
                    TaxNumber2 AS stcd2,
                    TaxNumber3 AS stcd3,
                    AddressID AS adrnr
        FROM I_Customer
        WHERE Customer = @ls_vbpa-kunnr
        INTO @DATA(ls_partner_data).
      ms_outdel_data-taxid = COND #( WHEN ls_partner_data-stcd3 IS NOT INITIAL THEN ls_partner_data-stcd3 ELSE ls_partner_data-stcd2 ).
      ms_outdel_data-tax_office = ls_partner_data-stcd1.
    ENDIF.
  ENDMETHOD.