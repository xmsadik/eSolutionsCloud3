  METHOD outgoing_invoice_save_bkpf.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE budat,
             defal  TYPE abap_boolean,
             txpty  TYPE zetr_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_inprf,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE zetr_e_invty,
             taxex TYPE zetr_e_taxex,
             taxty TYPE zetr_e_taxty,
             taxrt TYPE zetr_e_taxrt,
           END OF ty_tax_data,
           BEGIN OF ty_bkpf,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
             bldat TYPE bldat,
             erdat TYPE datum,
             erzet TYPE uzeit,
             waers TYPE waers,
             hwaer TYPE waers,
             kursf TYPE zetr_e_kursf,
             blart TYPE blart,
             usnam TYPE usnam,
           END OF ty_bkpf,
           BEGIN OF ty_bseg,
             buzei TYPE buzei,
             shkzg TYPE shkzg,
             hkont TYPE hkont,
             lokkt TYPE hkont,
             koart TYPE koart,
             kunnr TYPE lifnr,
             lifnr TYPE lifnr,
             wrbtr TYPE wrbtr_cs,
             dmbtr TYPE wrbtr_cs,
             mwskz TYPE mwskz,
             gsber TYPE gsber,
             werks TYPE werks_d,
           END OF ty_bseg.
    DATA: lt_bseg                TYPE STANDARD TABLE OF ty_bseg,
          ls_bseg_partner        TYPE ty_bseg,
          ls_bseg                TYPE ty_bseg,
          ls_bkpf                TYPE ty_bkpf,
          ls_tax_data            TYPE ty_tax_data,
          ls_company_data        TYPE ty_company,
          lt_taxpayer            TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer            TYPE ty_taxpayer,
          ls_document            TYPE zetr_t_oginv,
          ls_invoice_rule_input  TYPE zetr_s_invoice_rules_in,
          ls_invoice_rule_output TYPE zetr_s_invoice_rules_out,
          ls_bsec                TYPE i_journalentryitemonetimedata,
          lt_tax_acc             TYPE STANDARD TABLE OF zetr_t_fiacc,
          ls_bseg_tax            TYPE ty_bseg,
          lv_insrt               TYPE zetr_e_insrt.

    SELECT SINGLE accountingdocument AS belnr,
                  fiscalyear AS gjahr,
                  documentdate AS bldat,
                  accountingdocumentcreationdate AS erdat,
                  creationtime AS erzet,
                  transactioncurrency AS waers,
                  companycodecurrency AS hwaer,
                  absoluteexchangerate AS kursf,
                  accountingdocumenttype AS blart,
                  accountingdoccreatedbyuser AS usnam
      FROM i_journalentry
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
        AND isreversal = ''
        AND isreversed = ''
      INTO @ls_bkpf.
    CHECK ls_bkpf IS NOT INITIAL.

    SELECT accountingdocumentitem AS buzei,
           debitcreditcode AS shkzg,
           glaccount AS hkont,
           alternativeglaccount AS lokkt,
           financialaccounttype AS koart,
           customer AS kunnr,
           supplier AS lifnr,
           abs( amountintransactioncurrency ) AS wrbtr,
           abs( amountincompanycodecurrency ) AS dmbtr,
           taxcode AS mwskz,
           profitcenter AS gsber,
           plant AS werks
      FROM i_journalentryitem
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
        AND ledger = '0L'
      INTO TABLE @lt_bseg.

    ls_document-waers = ls_bkpf-waers.
    LOOP AT lt_bseg INTO ls_bseg_partner WHERE ( koart = 'K' OR koart = 'D' ) AND shkzg = 'S'.
      IF ls_bseg_partner-wrbtr IS INITIAL AND ls_bseg_partner-dmbtr IS NOT INITIAL.
        ls_bseg_partner-wrbtr = ls_bseg_partner-dmbtr.
        ls_document-waers = ls_bkpf-hwaer.
        ls_document-kursf = 1.
      ENDIF.
      ls_document-wrbtr += ls_bseg_partner-wrbtr.

      ls_document-werks = ls_bseg_partner-werks.
      ls_document-gsber = ls_bseg_partner-gsber.
    ENDLOOP.
    CHECK sy-subrc IS INITIAL.
    READ TABLE lt_bseg INTO ls_bseg WITH KEY koart = 'S'
                                             shkzg = 'H'.
    CHECK sy-subrc IS INITIAL.

    SELECT SINGLE taxid2
      FROM i_journalentryitemonetimedata
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
      INTO @ls_document-taxid.

    IF ls_document-taxid IS INITIAL AND ls_bseg_partner-kunnr IS NOT INITIAL.
      DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_bseg_partner-kunnr ).
    ELSEIF ls_document-taxid IS INITIAL AND ls_bseg_partner-lifnr IS NOT INITIAL.
      ls_partner_data = get_partner_register_data( iv_supplier = ls_bseg_partner-lifnr ).
    ENDIF.

    ls_document-taxid = ls_partner_data-bptaxnumber.
    ls_document-partner = ls_partner_data-businesspartner.
    ls_document-bldat = ls_bkpf-bldat.
    ls_document-werks = ls_bseg-werks.

    ls_invoice_rule_input-awtyp = iv_awtyp(4).
    ls_invoice_rule_input-fidty = ls_bkpf-blart.
    ls_invoice_rule_input-partner = ls_document-partner.
    ls_invoice_rule_input-werks = ls_bseg-werks.

    SELECT SINGLE datab, datbi, genid, prfid
      FROM zetr_t_eipar
      WHERE bukrs = @iv_bukrs
      INTO @ls_company_data.
    IF sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_false.
        ls_document-prfid = ls_invoice_rule_output-pidou.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass, regdt, defal, txpty
        FROM zetr_t_inv_ruser
        WHERE taxid = @ls_document-taxid
          AND regdt <= @ls_document-bldat
          INTO TABLE @lt_taxpayer.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.

        IF ls_taxpayer-txpty EQ 'KAMU'.
          ls_document-prfid = 'KAMU'.
        ENDIF.

        IF ls_document-prfid IS INITIAL.
          IF ls_company_data-prfid IS INITIAL.
            ls_company_data-prfid = 'TEMEL'.
          ENDIF.
          ls_document-prfid = ls_company_data-prfid.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND ls_document-prfid NE 'YOLCU'.
      SELECT SINGLE datab, datbi, genid
        FROM zetr_t_eapar
        WHERE bukrs = @iv_bukrs
        INTO @ls_company_data.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

      ls_document-prfid = 'EARSIV'.
      ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_true.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    CHECK ls_document-prfid IS NOT INITIAL.

    SELECT *
      FROM zetr_t_fiacc
      WHERE accty IN ('O','I')
      INTO TABLE @lt_tax_acc.
    SORT lt_tax_acc BY saknr.

    SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
      FROM i_companycode AS company
      INNER JOIN i_country AS country
        ON country~country = company~country
      WHERE company~companycode = @iv_bukrs
      INTO @DATA(ls_company_parameters).

    DATA lv_hkont TYPE hkont .
    LOOP AT lt_bseg INTO ls_bseg_tax.
      CLEAR ls_tax_data.
      "-- Lokkt kontrolü STASKAN 24.12.2021
      lv_hkont = ls_bseg_tax-lokkt .
      IF  lv_hkont IS INITIAL .
        lv_hkont = ls_bseg_tax-hkont .
      ENDIF.

      SELECT SINGLE invty, taxex, taxty, taxrt
        FROM zetr_t_taxmc
        WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
          AND mwskz = @ls_bseg_tax-mwskz
        INTO @ls_tax_data.
      IF sy-subrc EQ 0 AND ls_tax_data-taxrt EQ '0'.
        ls_document-texex = abap_true.
      ENDIF.

      READ TABLE lt_tax_acc WITH KEY saknr = lv_hkont BINARY SEARCH TRANSPORTING NO FIELDS.
      CHECK sy-subrc = 0.

      IF ls_bseg_tax-wrbtr IS INITIAL AND ls_bseg_tax-dmbtr IS NOT INITIAL.
        ls_bseg_tax-wrbtr = ls_bseg_tax-dmbtr.
      ENDIF.
      IF ls_bseg_tax-shkzg = 'S'.
        ls_bseg_tax-wrbtr = ls_bseg_tax-wrbtr * -1.
      ENDIF.
      ls_document-fwste += ls_bseg_tax-wrbtr.
      IF ls_bseg_tax-wrbtr IS INITIAL.
        ls_document-texex = abap_true.
      ENDIF.
      IF ls_document-invty IS INITIAL AND ls_bseg_tax-mwskz IS NOT INITIAL AND ls_tax_data IS NOT INITIAL.
        ls_document-invty = ls_tax_data-invty.
      ENDIF.
      IF ls_document-taxex IS INITIAL AND ls_bseg_tax-mwskz IS NOT INITIAL AND ls_tax_data IS NOT INITIAL.
        ls_document-taxex = ls_tax_data-taxex.
      ENDIF.
      IF ls_document-taxty IS INITIAL.
        ls_document-taxty = ls_tax_data-taxty. " AS 30.12.2021
      ENDIF.
    ENDLOOP.
    IF ls_document-fwste IS INITIAL.
      ls_document-texex = abap_true.
    ENDIF.
    IF ls_document-invty IS INITIAL AND ls_bseg_partner-mwskz IS NOT INITIAL.
      SELECT SINGLE invty, taxex
        FROM zetr_t_taxmc
        WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
          AND mwskz = @ls_bseg_partner-mwskz
        INTO @ls_tax_data.
      IF sy-subrc = 0.
        ls_document-invty = ls_tax_data-invty.
        ls_document-taxex = ls_tax_data-taxex.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-invui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-docty = ls_bkpf-blart.
    ls_document-awtyp = iv_awtyp(4).
    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-ernam = ls_bkpf-usnam.
    ls_document-erzet = ls_bkpf-erzet.
    ls_document-erdat = ls_bkpf-erdat.
    IF ls_document-kursf IS INITIAL.
      IF ls_bkpf-kursf IS NOT INITIAL.
        ls_document-kursf = ls_bkpf-kursf.
      ELSEIF ls_bkpf-waers = ls_bkpf-hwaer.
        ls_document-kursf = 1.
      ENDIF.
    ENDIF.

    CASE ls_document-prfid.
      WHEN 'EARSIV'.
        ls_invoice_rule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM zetr_t_easer
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eaxslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
      WHEN OTHERS.
        ls_invoice_rule_input-ityin = ls_document-invty.
        ls_invoice_rule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'IHRACAT'.
              WHEN 'YOLCU'.
                lv_insrt = 'YOLCU'.
              WHEN OTHERS.
                lv_insrt = 'YURTICI'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM zetr_t_eiser
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
                AND insrt = @lv_insrt
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                                    is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eixslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
    ENDCASE.
    rs_document = ls_document.
  ENDMETHOD.