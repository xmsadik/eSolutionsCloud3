  METHOD get_data_mkpf.
    SELECT SINGLE MaterialDocument AS mblnr, MaterialDocumentYear AS mjahr, AccountingDocumentType AS blart
      FROM I_MaterialDocumentHeader_2
      WHERE MaterialDocument = @ms_document-belnr
        AND MaterialDocumentYear = @ms_document-gjahr
      INTO @ms_goodsmvmt_data-mkpf.
    CHECK sy-subrc = 0.

    SELECT MaterialDocument AS mblnr, MaterialDocumentYear AS mjahr, MaterialDocumentItem AS zeile,
           QuantityInBaseUnit AS menge, MaterialBaseUnit AS meins, IsAutomaticallyCreated AS xauto,
           PurchaseOrder AS ebeln, PurchaseOrderItem AS ebelp, Material AS matnr, ProductName AS maktx,
           Customer AS kunnr, Supplier AS lifnr, IssuingOrReceivingPlant AS umwrk, IssuingOrReceivingStorageLoc AS umlgo
      FROM I_MaterialDocumentItem_2 AS Item
      LEFT OUTER JOIN I_ProductText AS ProductText
        ON  ProductText~Language = @sy-langu
        AND ProductText~Product = Item~material
       WHERE MaterialDocument = @ms_document-belnr
        AND MaterialDocumentYear = @ms_document-gjahr
      INTO TABLE @ms_goodsmvmt_data-mseg.

    SELECT PurchaseOrder AS ebeln, PurchaseOrderDate AS bedat
      FROM I_PurchaseOrderAPI01
      FOR ALL ENTRIES IN @ms_goodsmvmt_data-mseg
      WHERE PurchaseOrder = @ms_goodsmvmt_data-mseg-ebeln
      INTO TABLE @ms_goodsmvmt_data-ekko.
    IF sy-subrc = 0.
      SELECT PurchaseOrder AS ebeln, PurchaseOrderItem AS ebelp, Material AS matnr,
             ProductName AS maktx, PurchaseOrderItemText AS txz01
        FROM I_PurchaseOrderItemAPI01 AS Item
          LEFT OUTER JOIN I_ProductText AS ProductText
            ON  ProductText~Language = @sy-langu
            AND ProductText~Product = Item~material
        FOR ALL ENTRIES IN @ms_goodsmvmt_data-ekko
        WHERE PurchaseOrder = @ms_goodsmvmt_data-ekko-ebeln
        INTO TABLE @ms_goodsmvmt_data-ekpo.
    ENDIF.

    SELECT SINGLE companycode AS bukrs,
                  currency AS waers,
                  country AS land1,
                  CASE WHEN CountryChartOfAccounts IS NOT INITIAL THEN CountryChartOfAccounts
                  ELSE chartofaccounts END AS ktopl
      FROM I_CompanyCode
      WHERE companycode = @ms_document-bukrs
      INTO CORRESPONDING FIELDS OF @ms_goodsmvmt_data-t001.

    LOOP AT ms_goodsmvmt_data-mseg INTO DATA(ls_mseg_partner).
      CHECK ls_mseg_partner-xauto IS INITIAL.
      IF ls_mseg_partner-kunnr IS NOT INITIAL.
        SELECT SINGLE TaxNumber1 AS stcd1,
                      TaxNumber2 AS stcd2,
                      TaxNumber3 AS stcd3,
                      AddressID AS adrnr
          FROM I_Customer
          WHERE Customer = @ls_mseg_partner-kunnr
          INTO @DATA(ls_partner_data).
      ELSEIF ls_mseg_partner-lifnr IS NOT INITIAL.
        SELECT SINGLE TaxNumber1 AS stcd1,
                      TaxNumber2 AS stcd2,
                      TaxNumber3 AS stcd3,
                      AddressID AS adrnr
          FROM I_Supplier
          WHERE Supplier = @ls_mseg_partner-lifnr
          INTO @ls_partner_data.
      ELSEIF ls_mseg_partner-umlgo IS NOT INITIAL.
        SELECT SINGLE AddressID
          FROM I_StorageLocationAddress
          WHERE Plant = @ls_mseg_partner-umwrk
            AND StorageLocation = @ls_mseg_partner-umlgo
          INTO @ls_partner_data-adrnr.
        SELECT SINGLE taxof
          FROM zetr_t_cmpin
          WHERE bukrs = @ms_document-bukrs
          INTO @ls_partner_data-stcd1.
        ls_partner_data-stcd2 = mv_company_taxid.
      ELSEIF ls_mseg_partner-umwrk IS NOT INITIAL.
        SELECT SINGLE AddressID
          FROM I_Plant
          WHERE Plant = @ls_mseg_partner-umwrk
          INTO @ls_partner_data-adrnr.
        SELECT SINGLE taxof
          FROM zetr_t_cmpin
          WHERE bukrs = @ms_document-bukrs
          INTO @ls_partner_data-stcd1.
        ls_partner_data-stcd2 = mv_company_taxid.
      ENDIF.
    ENDLOOP.
    ms_goodsmvmt_data-taxid = COND #( WHEN ls_partner_data-stcd3 IS NOT INITIAL THEN ls_partner_data-stcd3 ELSE ls_partner_data-stcd2 ).
    ms_goodsmvmt_data-tax_office = ls_partner_data-stcd1.
    ms_goodsmvmt_data-address_number = ls_partner_data-adrnr.
  ENDMETHOD.