  METHOD get_data_manu.
    ms_manual_data-head = ms_document.
    SELECT *
      FROM zetr_t_ogdli
      WHERE docui = @ms_manual_data-head-docui
      INTO TABLE @ms_manual_data-items.

    SELECT SINGLE companycode AS bukrs,
                  currency AS waers,
                  country AS land1,
                  CASE WHEN CountryChartOfAccounts IS NOT INITIAL THEN CountryChartOfAccounts
                  ELSE chartofaccounts END AS ktopl
      FROM I_CompanyCode
      WHERE companycode = @ms_document-bukrs
      INTO CORRESPONDING FIELDS OF @ms_manual_data-t001.

    IF ms_document-partner IS NOT INITIAL.
      SELECT SINGLE TaxNumber1 AS stcd1,
                    TaxNumber2 AS stcd2,
                    TaxNumber3 AS stcd3,
                    AddressID AS adrnr
        FROM I_Customer
        WHERE Customer = @ms_document-partner
        INTO @DATA(ls_partner_data).
      IF sy-subrc <> 0.
        SELECT SINGLE TaxNumber1 AS stcd1,
                      TaxNumber2 AS stcd2,
                      TaxNumber3 AS stcd3,
                      AddressID AS adrnr
          FROM I_Supplier
          WHERE Supplier = @ms_document-partner
          INTO @ls_partner_data.
      ENDIF.
    ELSEIF ms_document-umlgo IS NOT INITIAL.
      SELECT SINGLE AddressID
        FROM I_StorageLocationAddress
        WHERE Plant = @ms_document-umwrk
          AND StorageLocation = @ms_document-umlgo
        INTO @ls_partner_data-adrnr.
      SELECT SINGLE taxof
        FROM zetr_t_cmpin
        WHERE bukrs = @ms_document-bukrs
        INTO @ls_partner_data-stcd1.
      ls_partner_data-stcd2 = mv_company_taxid.
    ELSEIF ms_document-umwrk IS NOT INITIAL.
      SELECT SINGLE AddressID
        FROM I_Plant
        WHERE Plant = @ms_document-umwrk
        INTO @ls_partner_data-adrnr.
      SELECT SINGLE taxof
        FROM zetr_t_cmpin
        WHERE bukrs = @ms_document-bukrs
        INTO @ls_partner_data-stcd1.
      ls_partner_data-stcd2 = mv_company_taxid.
    ENDIF.
    ms_outdel_data-taxid = COND #( WHEN ls_partner_data-stcd3 IS NOT INITIAL THEN ls_partner_data-stcd3 ELSE ls_partner_data-stcd2 ).
    ms_outdel_data-tax_office = ls_partner_data-stcd1.
  ENDMETHOD.