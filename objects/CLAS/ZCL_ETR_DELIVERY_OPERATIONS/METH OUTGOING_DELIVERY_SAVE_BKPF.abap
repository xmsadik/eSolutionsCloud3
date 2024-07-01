  METHOD outgoing_delivery_save_bkpf.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE datum,
             defal  TYPE abap_boolean,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_dlprf,
           END OF ty_company,
           BEGIN OF ty_bkpf,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
             bldat TYPE datum,
             cpudt TYPE datum,
             cputm TYPE uzeit,
             waers TYPE waers,
             hwaer TYPE waers,
             kursf TYPE zetr_e_kursf,
             blart TYPE blart,
             usnam TYPE abp_creation_user,
           END OF ty_bkpf,
           BEGIN OF ty_bseg,
             buzei TYPE buzei,
             shkzg TYPE shkzg,
             hkont TYPE hkont,
             lokkt TYPE hkont,
             koart TYPE koart,
             kunnr TYPE zetr_e_partner,
             lifnr TYPE zetr_e_partner,
             wrbtr TYPE wrbtr_cs,
             dmbtr TYPE wrbtr_cs,
             mwskz TYPE mwskz,
             gsber TYPE gsber,
             werks TYPE werks_d,
           END OF ty_bseg.
    DATA: lt_bseg          TYPE STANDARD TABLE OF ty_bseg,
          ls_bseg_partner  TYPE ty_bseg,
          ls_bkpf          TYPE ty_bkpf,
          ls_company_data  TYPE ty_company,
          lt_taxpayer      TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer      TYPE ty_taxpayer,
          ls_document      TYPE zetr_t_ogdlv,
          ls_edrule_input  TYPE zetr_s_delivery_rules_in,
          ls_edrule_output TYPE zetr_s_delivery_rules_out,
          ls_bsec          TYPE i_journalentryitemonetimedata.

    DO 1000 TIMES.
      SELECT SINGLE accountingdocument AS belnr,
                    fiscalyear AS gjahr,
                    documentdate AS bldat,
                    accountingdocumentcreationdate AS cpudt,
                    creationtime AS cputm,
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
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO '0.1' SECONDS.
      ENDIF.
    ENDDO.
    CHECK ls_bkpf IS NOT INITIAL.

    SELECT SINGLE datab, datbi, genid, prfid
      FROM zetr_t_edpar
      WHERE bukrs = @iv_bukrs
      INTO @ls_company_data.
    CHECK sy-subrc = 0 AND ls_bkpf-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

    SELECT accountingdocumentitem AS buzei,
           debitcreditcode AS shkzg,
           glaccount AS hkont,
           alternativeglaccount AS lokkt,
           financialaccounttype AS koart,
           customer AS kunnr,
           supplier AS lifnr,
           amountintransactioncurrency AS wrbtr,
           amountincompanycodecurrency AS dmbtr,
           taxcode AS mwskz,
           profitcenter AS gsber,
           plant AS werks
      FROM i_journalentryitem
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
        AND ledger = '0L'
      INTO TABLE @lt_bseg.
    LOOP AT lt_bseg INTO ls_bseg_partner WHERE ( koart = 'K' OR koart = 'D' ) AND shkzg = 'S'.
      ls_document-werks = ls_bseg_partner-werks.
      ls_document-gsber = ls_bseg_partner-gsber.
    ENDLOOP.
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

    ls_document-bldat = ls_bkpf-bldat.
    ls_document-ernam = ls_bkpf-usnam.

    ls_edrule_input-awtyp = iv_awtyp.
    ls_edrule_input-fidty = ls_bkpf-blart.
    ls_edrule_input-partner = ls_document-partner.
    ls_edrule_input-werks = ls_document-werks.

    CLEAR ls_edrule_output.
    ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'P'
                                           is_rule_input  = ls_edrule_input ).
    CHECK ls_edrule_output IS NOT INITIAL AND ls_edrule_output-excld IS INITIAL.
    IF ls_edrule_output-pidou IS INITIAL.
      ls_edrule_output-pidou = 'TEMEL'.
    ENDIF.
    IF ls_edrule_output-dtyou IS INITIAL.
      ls_edrule_output-dtyou = 'SEVK'.
    ENDIF.
    ls_document-prfid = ls_edrule_output-pidou.
    ls_document-dlvty = ls_edrule_output-dtyou.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass, regdt, defal
        FROM zetr_t_dlv_ruser
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
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-dlvui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-objtype = 'BKPF'.
    ls_document-ernam = ls_bkpf-usnam.
    ls_document-erdat = ls_bkpf-cpudt.
    ls_document-erzet = ls_bkpf-cputm.

    ls_edrule_input-dtyin = ls_document-dlvty.
    ls_edrule_input-pidin = ls_document-prfid.
    IF ls_company_data-genid IS NOT INITIAL.
      CLEAR ls_edrule_output.
      ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'S'
                                             is_rule_input  = ls_edrule_input ).
      IF ls_edrule_output IS NOT INITIAL.
        ls_document-serpr = ls_edrule_output-serpr.
      ELSE.
        SELECT SINGLE serpr
          FROM zetr_t_edser
          WHERE bukrs = @iv_bukrs
            AND maisp = @abap_true
          INTO @ls_document-serpr.
      ENDIF.
    ENDIF.

    CLEAR ls_edrule_output.
    ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'X'
                                           is_rule_input  = ls_edrule_input ).
    IF ls_edrule_output IS NOT INITIAL.
      ls_document-xsltt = ls_edrule_output-xsltt.
    ELSE.
      SELECT SINGLE xsltt
        FROM zetr_t_edxslt
        WHERE bukrs = @iv_bukrs
          AND deflt = @abap_true
        INTO @ls_document-xsltt.
    ENDIF.
    es_document = ls_document.
  ENDMETHOD.