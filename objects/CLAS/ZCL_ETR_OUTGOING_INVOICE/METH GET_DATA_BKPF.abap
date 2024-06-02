  METHOD get_data_bkpf.
    SELECT SINGLE companycode AS bukrs,
                  accountingdocument AS belnr,
                  fiscalyear AS gjahr,
                  companycodecurrency AS hwaer,
                  transactioncurrency AS waers,
                  documentdate AS bldat,
                  accountingdocumenttype AS blart,
                  absoluteexchangerate AS kursf
       FROM i_journalentry
       WHERE companycode = @ms_document-bukrs
         AND accountingdocument = @ms_document-belnr
         AND fiscalyear = @ms_document-gjahr
       INTO @ms_accdoc_data-bkpf.
    CHECK sy-subrc IS INITIAL.

    SELECT SINGLE company~companycode AS bukrs,
                  company~currency AS waers,
                  company~country AS land1,
*                  CASE WHEN company~CountryChartOfAccounts IS NOT INITIAL THEN CountryChartOfAccounts
*                  ELSE company~chartofaccounts END AS ktopl,
                  company~chartofaccounts AS ktopl,
                  country~taxcalculationprocedure AS kalsm
      FROM I_CompanyCode AS company
      INNER JOIN i_country AS country
        ON country~country = company~country
      WHERE companycode = @ms_document-bukrs
      INTO CORRESPONDING FIELDS OF @ms_accdoc_data-t001.

    SELECT country AS land1, CountryName AS landx
      FROM I_CountryText
      WHERE Language = @sy-langu
        AND Country = @ms_accdoc_data-t001-land1
      INTO TABLE @ms_accdoc_data-t005.

    SELECT SINGLE AccountingDocumentItem AS buzei,
                  StreetAddressName AS stras,
                  PostalCode AS pstlz,
                  Country AS land1,
                  Region AS regio,
                  CityName AS ort01,
                  BusinessPartnerName1 AS name1,
                  BusinessPartnerName2 AS name2,
                  TaxID1 AS stcd1,
                  TaxID2 AS stcd2
      FROM i_journalentryitemonetimedata
       WHERE companycode = @ms_document-bukrs
         AND accountingdocument = @ms_document-belnr
         AND fiscalyear = @ms_document-gjahr
      INTO @ms_accdoc_data-bsec.
    IF sy-subrc IS INITIAL.
      ms_accdoc_data-taxid = ms_accdoc_data-bsec-stcd2.
      ms_accdoc_data-tax_office = ms_accdoc_data-bsec-stcd1.

      IF ms_accdoc_data-bsec-land1 IS NOT INITIAL AND  ms_accdoc_data-t005 IS INITIAL. "AS
        SELECT country AS land1, CountryName AS landx
          FROM I_CountryText
          WHERE Language = @sy-langu
            AND Country = @ms_accdoc_data-bsec-land1
          APPENDING TABLE @ms_accdoc_data-t005.
      ENDIF.

      IF ms_accdoc_data-bsec-regio IS NOT INITIAL.
        SELECT Country AS land1, Region AS regio, RegionName AS bezei
            FROM I_RegionText
            WHERE Language = @sy-langu
              AND Country = @ms_accdoc_data-bsec-land1
              AND Region = @ms_accdoc_data-bsec-regio
            INTO TABLE @ms_accdoc_data-t005u.
      ENDIF.
    ENDIF.

    SELECT item~AccountingDocumentItem AS buzei,
           item~financialaccounttype AS koart,
           item~debitcreditcode AS shkzg,
           item~glaccount AS hkont,
           GLAccountLongName AS txt50,
           abs( amountincompanycodecurrency ) AS dmbtr,
           abs( amountintransactioncurrency ) AS wrbtr,
           NetDueDate AS netdt,
           AlternativeGLAccount AS lokkt,
           Customer AS kunnr,
           Supplier AS lifnr,
           Product AS matnr,
           DocumentItemText AS sgtxt,
           TaxCode AS meskz
      FROM i_journalentryitem AS item
        LEFT OUTER JOIN i_glaccounttext AS glaccounttext
          ON  glaccounttext~Language = @sy-langu
          AND glaccounttext~ChartOfAccounts = @ms_accdoc_data-t001-ktopl
          AND glaccounttext~GLAccount = item~GLAccount
       WHERE item~companycode = @ms_document-bukrs
         AND item~accountingdocument = @ms_document-belnr
         AND item~fiscalyear = @ms_document-gjahr
         AND item~Ledger = '0L'
      INTO TABLE @ms_accdoc_data-bseg.
    IF sy-subrc IS INITIAL.
      LOOP AT ms_accdoc_data-bseg INTO DATA(ls_bseg) USING KEY by_koart WHERE koart = 'D'
                                                             AND shkzg = 'S'.
        IF ms_accdoc_data-bseg_partner IS INITIAL.
          ms_accdoc_data-bseg_partner = ls_bseg.
        ELSE.
          ms_accdoc_data-bseg_partner-dmbtr += ls_bseg-dmbtr.
          ms_accdoc_data-bseg_partner-wrbtr += ls_bseg-wrbtr.
        ENDIF.
      ENDLOOP.
      IF sy-subrc IS NOT INITIAL.
        LOOP AT ms_accdoc_data-bseg INTO ls_bseg USING KEY by_koart WHERE koart = 'K'
                                                               AND shkzg = 'S'.
          IF ms_accdoc_data-bseg_partner IS INITIAL.
            ms_accdoc_data-bseg_partner = ls_bseg.
          ELSE.
            ms_accdoc_data-bseg_partner-dmbtr += ls_bseg-dmbtr.
            ms_accdoc_data-bseg_partner-wrbtr += ls_bseg-wrbtr.
          ENDIF.
        ENDLOOP.
      ENDIF.

      IF ms_accdoc_data-bsec IS INITIAL.
        IF ms_accdoc_data-bseg_partner-kunnr IS NOT INITIAL.
          SELECT SINGLE TaxNumber1 AS stcd1,
                        TaxNumber2 AS stcd2,
                        TaxNumber3 AS stcd3,
                        AddressID AS adrnr
            FROM I_Customer
            WHERE Customer = @ms_accdoc_data-bseg_partner-kunnr
            INTO @DATA(ls_partner_data).
        ELSEIF ms_accdoc_data-bseg_partner-lifnr IS NOT INITIAL.
          SELECT SINGLE TaxNumber1 AS stcd1,
                        TaxNumber2 AS stcd2,
                        TaxNumber3 AS stcd3,
                        AddressID AS adrnr
            FROM I_Supplier
            WHERE Supplier = @ms_accdoc_data-bseg_partner-lifnr
            INTO @ls_partner_data.
        ENDIF.
        ms_accdoc_data-taxid = COND #( WHEN ls_partner_data-stcd3 IS NOT INITIAL THEN ls_partner_data-stcd3 ELSE ls_partner_data-stcd2 ).
        ms_accdoc_data-tax_office = ls_partner_data-stcd1.
        ms_accdoc_data-address_number = ls_partner_data-adrnr.
      ENDIF.

      SELECT *
        FROM zetr_t_fiacc
        WHERE ktopl = @ms_accdoc_data-t001-ktopl
        INTO TABLE @ms_accdoc_data-accounts.
    ENDIF.
  ENDMETHOD.