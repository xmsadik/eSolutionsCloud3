  METHOD outgoing_invoice_save_rmrp.
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
           END OF ty_tax_data,
           BEGIN OF ty_rbkp,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
             bldat TYPE bldat,
             lifnr TYPE lifnr,
             xrech TYPE xrech,
             stblg TYPE belnr_d,
             waers TYPE waers,
             cpudt TYPE datum,
             rmwwr TYPE rmwwr,
             wmwst TYPE wrbtr_cs,
             mwskz TYPE mwskz,
             kursf TYPE zetr_e_kursf,
             blart TYPE blart,
             usnam TYPE usnam,
           END OF ty_rbkp.
    DATA: ls_rbkp                TYPE ty_rbkp,
          ls_tax_data            TYPE ty_tax_data,
          ls_company_data        TYPE ty_company,
          lt_taxpayer            TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer            TYPE ty_taxpayer,
          ls_document            TYPE zetr_t_oginv,
          ls_invoice_rule_input  TYPE zetr_s_invoice_rules_in,
          ls_invoice_rule_output TYPE zetr_s_invoice_rules_out,
          lv_insrt               TYPE zetr_e_insrt.

    SELECT SINGLE invoice~supplierinvoice AS belnr,
                  invoice~fiscalyear AS gjahr,
                  invoice~documentdate AS bldat,
                  invoice~invoicingparty AS lifnr,
                  invoice~isinvoice AS xrech,
                  invoice~reversedocument AS stblg,
                  invoice~documentcurrency AS waers,
                  invoice~creationdate AS cpudt,
                  invoice~invoicegrossamount AS rmwwr,
                  tax~taxamount AS wmwst,
                  tax~taxcode AS mwskz,
                  invoice~exchangerate AS kursf,
                  invoice~accountingdocumenttype AS blart,
                  invoice~lastchangedbyuser AS usnam
      FROM i_supplierinvoiceapi01 AS invoice
      LEFT OUTER JOIN i_supplierinvoicetaxapi01 AS tax
        ON  tax~supplierinvoice = invoice~supplierinvoice
        AND tax~fiscalyear = invoice~fiscalyear
      WHERE invoice~supplierinvoice = @iv_belnr
        AND invoice~fiscalyear = @iv_gjahr
      INTO @ls_rbkp.

    CHECK ls_rbkp IS NOT INITIAL
      AND ls_rbkp-xrech = ''
      AND ls_rbkp-stblg = ''.

    DATA(ls_partner_data) = get_partner_register_data( iv_supplier = ls_rbkp-lifnr ).

    ls_document-bldat = ls_rbkp-bldat.

    ls_invoice_rule_input-awtyp = iv_awtyp.
    ls_invoice_rule_input-mmdty = ls_rbkp-blart.
    ls_invoice_rule_input-partner = ls_partner_data-businesspartner.

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
    " determine invoice type
    IF ls_document-invty IS INITIAL OR ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.
      IF sy-subrc = 0 AND ls_rbkp-mwskz IS NOT INITIAL.
        SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
          FROM i_companycode AS company
          INNER JOIN i_country AS country
            ON country~country = company~country
          WHERE company~companycode = @iv_bukrs
          INTO @DATA(ls_company_parameters).

        SELECT SINGLE invty, taxex, taxty
          FROM zetr_t_taxmc
          WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
            AND mwskz = @ls_rbkp-mwskz
          INTO @ls_tax_data.
        IF sy-subrc = 0.
          IF ls_document-invty IS INITIAL.
            ls_document-invty = ls_tax_data-invty.
          ENDIF.
          IF ls_document-taxex IS INITIAL.
            ls_document-taxex = ls_tax_data-taxex.
          ENDIF.
          IF ls_document-taxty IS INITIAL.
            ls_document-taxty = ls_tax_data-taxty.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-invui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-docty = ls_rbkp-blart.
    ls_document-awtyp = iv_awtyp(4).
    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-partner = ls_partner_data-businesspartner.
    ls_document-wrbtr = ls_rbkp-rmwwr.
    ls_document-fwste = ls_rbkp-wmwst.
    ls_document-kursf = ls_rbkp-kursf.
    ls_document-ernam = ls_rbkp-usnam.
    ls_document-erdat = ls_rbkp-cpudt.
    IF ls_document-fwste IS INITIAL.
      ls_document-texex = abap_true.
    ENDIF.
    ls_document-waers = ls_rbkp-waers.

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