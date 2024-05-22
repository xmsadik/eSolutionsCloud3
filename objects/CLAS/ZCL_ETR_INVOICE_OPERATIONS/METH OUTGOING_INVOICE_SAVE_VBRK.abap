  METHOD outgoing_invoice_save_vbrk.
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
           BEGIN OF ty_vbrk,
             vbeln TYPE belnr_d,
             fkdat TYPE datum,
             fkart TYPE zetr_e_fkart,
             vkorg TYPE zetr_e_vkorg,
             vtweg TYPE zetr_e_vtweg,
             rfbsk TYPE c LENGTH 1,
             ernam TYPE usnam,
             erdat TYPE datum,
             erzet TYPE uzeit,
             kurrf TYPE zetr_e_kursf,
             waerk TYPE waers,
           END OF ty_vbrk,
           BEGIN OF ty_vbrp,
             posnr TYPE sd_sls_document_item,
             gsber TYPE gsber,
             werks TYPE werks_d,
             fkimg TYPE menge_d,
             netwr TYPE p LENGTH 15 DECIMALS 2,
             mwsbp TYPE wrbtr_cs,
             mwskz TYPE mwskz,
           END OF ty_vbrp,
           BEGIN OF ty_vbpa,
             parvw TYPE c LENGTH 2,
             kunnr TYPE zetr_e_partner,
           END OF ty_vbpa.
    DATA: ls_tax_data            TYPE ty_tax_data,
          ls_company_data        TYPE ty_company,
          lt_taxpayer            TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer            TYPE ty_taxpayer,
          lt_vbpa                TYPE TABLE OF ty_vbpa,
          ls_vbpa                TYPE ty_vbpa,
          ls_vbrk                TYPE ty_vbrk,
          lt_vbrp                TYPE TABLE OF ty_vbrp,
          ls_vbrp                TYPE ty_vbrp,
          ls_document            TYPE zetr_t_oginv,
          ls_invoice_rule_input  TYPE zetr_s_invoice_rules_in,
          ls_invoice_rule_output TYPE zetr_s_invoice_rules_out,
          ls_muhattap            TYPE zetr_t_othp,
          lv_insrt               TYPE zetr_e_insrt,
          lv_parvw               TYPE c LENGTH 2.

    SELECT SINGLE *
      FROM zetr_t_oginv
      WHERE awtyp = @iv_awtyp
        AND belnr = @iv_belnr
      INTO @ls_document.
    IF sy-subrc = 0.
      SELECT SINGLE billingdocumentdate
        FROM i_billingdocument
        WHERE billingdocument = @iv_belnr
        INTO @ls_document-bldat.
      IF sy-subrc IS INITIAL.
        SELECT SUM( netamount ) AS wrbtr,
               SUM( taxamount ) AS fwste
          FROM i_billingdocumentitem
          WHERE billingdocument = @iv_belnr
          INTO (@ls_document-wrbtr, @ls_document-fwste).

        UPDATE zetr_t_oginv
          SET bldat = @ls_document-bldat,
              wrbtr = @ls_document-wrbtr,
              fwste = @ls_document-fwste
          WHERE docui = @ls_document-docui.
        COMMIT WORK.
      ENDIF.
    ENDIF.
    CHECK ls_document IS INITIAL.

    SELECT SINGLE billingdocument AS vbeln,
                  billingdocumentdate AS fkdat,
                  billingdocumenttype AS fkart,
                  salesorganization AS vkorg,
                  distributionchannel AS vtweg,
                  accountingtransferstatus AS rfbsk,
                  createdbyuser AS ernam,
                  creationdate AS erdat,
                  creationtime AS erzet,
                  accountingexchangerate AS kurrf,
                  transactioncurrency AS waerk
      FROM i_billingdocument
      WHERE billingdocument = @iv_belnr
        AND billingdocumentiscancelled = ''
        AND cancelledbillingdocument = ''
      INTO @ls_vbrk.
    CHECK ls_vbrk IS NOT INITIAL.

    SELECT billingdocumentitem AS posnr,
           businessarea AS gsber,
           plant AS werks,
           billingquantity AS fkimg,
           netamount AS netwr,
           taxamount AS mwsbp,
           taxcode AS mwskz
      FROM i_billingdocumentitem
      WHERE billingdocument = @iv_belnr
      INTO TABLE @lt_vbrp.

    SELECT partnerfunction AS parvw, customer AS kunnr
      FROM i_billingdocumentpartner
      WHERE billingdocument = @iv_belnr
      INTO TABLE @lt_vbpa.

    SORT lt_vbpa BY parvw.
    READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = 'RE' BINARY SEARCH.
    IF sy-subrc <> 0.
      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = 'AG' BINARY SEARCH.
    ENDIF.
    CHECK sy-subrc = 0.

    DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_vbpa-kunnr ).
    ls_document-taxid = ls_partner_data-bptaxnumber.
    ls_document-partner = ls_partner_data-businesspartner.


    READ TABLE lt_vbrp INTO ls_vbrp INDEX 1.
    CHECK sy-subrc = 0.

    ls_document-bldat = ls_vbrk-fkdat.

    ls_invoice_rule_input-awtyp = iv_awtyp.
    ls_invoice_rule_input-sddty = ls_vbrk-fkart.
    ls_invoice_rule_input-partner = ls_document-partner.
    ls_invoice_rule_input-vkorg = ls_vbrk-vkorg.
    ls_invoice_rule_input-vtweg = ls_vbrk-vtweg.
    ls_invoice_rule_input-werks = ls_vbrp-werks.
    ls_invoice_rule_input-vbeln = ls_vbrk-vbeln.

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

    IF ls_document-prfid NE 'IHRACAT' AND
       ls_document-prfid NE 'YOLCU'.
      CHECK ls_vbrk-rfbsk CA 'CD'.
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

    IF ls_document-invty IS INITIAL OR ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.
      IF sy-subrc = 0 AND ls_vbrp-mwskz IS NOT INITIAL.
        SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
          FROM i_companycode AS company
          INNER JOIN i_country AS country
            ON country~country = company~country
          WHERE company~companycode = @iv_bukrs
          INTO @DATA(ls_company_parameters).
        SELECT SINGLE invty, taxex, taxty
          FROM zetr_t_taxmc
          WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
            AND mwskz = @ls_vbrp-mwskz
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

    ls_document-docty = ls_vbrk-fkart.
    ls_document-awtyp = iv_awtyp(4).
    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-erzet = ls_vbrk-erzet.
    ls_document-kursf = ls_vbrk-kurrf.
    ls_document-waers = ls_vbrk-waerk.
    ls_document-ernam = ls_vbrk-ernam.
    ls_document-vkorg = ls_vbrk-vkorg.
    ls_document-vtweg = ls_vbrk-vtweg.

    LOOP AT lt_vbrp INTO ls_vbrp.
      CHECK ls_vbrp-fkimg IS NOT INITIAL.
      ls_document-wrbtr += ls_vbrp-netwr.
      ls_document-fwste += ls_vbrp-mwsbp.
      ls_document-wrbtr += ls_vbrp-mwsbp.
      IF ls_vbrp-mwsbp IS INITIAL OR ls_vbrp-netwr IS INITIAL.
        ls_document-texex = abap_true.
      ENDIF.
      ls_document-werks = ls_vbrp-werks.
      ls_document-gsber = ls_vbrp-gsber.
    ENDLOOP.

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
* AS 07.01.2022
    IF ls_document-prfid EQ 'IHRACAT' .
      SELECT SINGLE *
        FROM zetr_t_othp
        WHERE prtty EQ 'C'
        INTO @ls_muhattap.

      SELECT aliass, regdt, defal
            FROM zetr_t_inv_ruser
            WHERE taxid = @ls_muhattap-taxid
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
      ENDIF.
    ENDIF.
    rs_document = ls_document.
  ENDMETHOD.