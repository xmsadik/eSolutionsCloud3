  METHOD accounting_document_save.
    CHECK is_accountingdocheader-referencedocumenttype(4) = 'BKPF' AND
          is_accountingdocheader-isreversaldocument = abap_false AND
          is_accountingdocheader-reversedocument IS INITIAL.

    SELECT SINGLE *
      FROM zetr_ddl_i_company_information
      WHERE companycode = @is_accountingdocheader-companycode
      INTO @DATA(ls_company_info).
    CHECK sy-subrc = 0.

    TRY.
        DATA(ls_edocument) = VALUE zetr_t_oginv( docui = cl_system_uuid=>create_uuid_c22_static( )
                                                 bukrs = is_accountingdocheader-companycode
                                                 gjahr = is_accountingdocheader-fiscalyear
                                                 awtyp = is_accountingdocheader-referencedocumenttype
                                                 waers = is_accountingdocheader-transactioncurrency
                                                 kursf = is_accountingdocheader-exchangerate
                                                 bldat = is_accountingdocheader-documentdate
                                                 ernam = is_accountingdocheader-accountingdoccreatedbyuser
                                                 erdat = is_accountingdocheader-accountingdocumentcreationdate
                                                 erzet = is_accountingdocheader-creationtime ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    LOOP AT it_accountingdocitems INTO DATA(ls_accountingdocitem_partner) WHERE ( financialaccounttype = 'D' OR
                                                                                  financialaccounttype = 'K' )
                                                                            AND debitcreditcode = 'S'.
      IF ls_accountingdocitem_partner-amountintransactioncurrency IS INITIAL AND ls_accountingdocitem_partner-amountincompanycodecurrency IS NOT INITIAL.
        ls_accountingdocitem_partner-amountintransactioncurrency = ls_accountingdocitem_partner-amountincompanycodecurrency.
        ls_edocument-waers = is_accountingdocheader-companycodecurrency.
        ls_edocument-kursf = 1.
      ENDIF.
      ls_edocument-wrbtr += ls_accountingdocitem_partner-amountintransactioncurrency.

      ls_edocument-werks = ls_accountingdocitem_partner-plant.
      ls_edocument-gsber = ls_accountingdocitem_partner-businessarea.
    ENDLOOP.
    CHECK ls_accountingdocitem_partner IS NOT INITIAL.

    CASE ls_accountingdocitem_partner-debitcreditcode.
      WHEN 'S'.
        CASE ls_accountingdocitem_partner-financialaccounttype.
          WHEN 'D'.
            DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_accountingdocitem_partner-customer ).
          WHEN 'K'.
            ls_partner_data = get_partner_register_data( iv_supplier = ls_accountingdocitem_partner-supplier ).
        ENDCASE.
        ls_edocument-partner = ls_partner_data-businesspartner.
        ls_edocument-aliass = ls_partner_data-aliass.
        ls_edocument-taxid = ls_partner_data-bptaxnumber.
        DATA(ls_invoice_rules_input) = VALUE zetr_s_invoice_rules_in( awtyp = 'BKPF'
                                                                      werks = ls_edocument-werks
                                                                      fidty = is_accountingdocheader-accountingdocumenttype
                                                                      partner = ls_partner_data-businesspartner ).
        DATA(ls_invoice_rules_output) = get_einvoice_rule( iv_rule_type  = 'P'
                                                           is_rule_input = ls_invoice_rules_input ).
        IF ( ls_invoice_rules_output IS NOT INITIAL AND
             ls_invoice_rules_output-excld = abap_false AND
             ls_partner_data-registerdate IS NOT INITIAL AND
             ls_partner_data-registerdate <= is_accountingdocheader-documentdate ) OR
            ( ls_invoice_rules_output-pidou = 'IHRACAT' OR ls_invoice_rules_output-pidou = 'YOLCU' ).
          SELECT SINGLE datab, datbi, prfid
            FROM zetr_t_eipar
            WHERE bukrs = @mv_company_code
            INTO @DATA(ls_invoice_parameters).
        ELSE.
          CLEAR ls_invoice_rules_output.
          ls_invoice_rules_output = get_earchive_rule( iv_rule_type  = 'P'
                                                       is_rule_input = ls_invoice_rules_input ).
          CHECK ls_invoice_rules_output IS NOT INITIAL AND ls_invoice_rules_output-excld = abap_false.
          SELECT SINGLE datab, datbi, 'EARSIV' AS prfid
            FROM zetr_t_eapar
            WHERE bukrs = @mv_company_code
            INTO @ls_invoice_parameters.
        ENDIF.
        CHECK sy-subrc = 0 AND is_accountingdocheader-documentdate BETWEEN ls_invoice_parameters-datab AND ls_invoice_parameters-datbi.
        ls_edocument-prfid = COND #( WHEN ls_invoice_rules_output-pidou IS NOT INITIAL THEN ls_invoice_rules_output-pidou ELSE ls_invoice_parameters-prfid ).
        ls_edocument-invty = ls_invoice_rules_output-ityou.
        ls_edocument-taxex = ls_invoice_rules_output-taxex.

        SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
          FROM i_companycode AS company
          INNER JOIN i_country AS country
            ON country~country = company~country
          WHERE company~companycode = @is_accountingdocheader-companycode
          INTO @DATA(ls_company_parameters).

        SELECT saknr, accty, taxty
          FROM zetr_t_fiacc
          FOR ALL ENTRIES IN @it_accountingdocitems
          WHERE ktopl = @ls_company_parameters-chartofaccounts
            AND saknr = @it_accountingdocitems-glaccount
            AND accty IN ('O','I')
          INTO TABLE @DATA(lt_account_parameters).
        SORT lt_account_parameters BY saknr.

        SELECT *
          FROM zetr_t_taxmc
          FOR ALL ENTRIES IN @it_accountingdocitems
          WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
            AND mwskz = @it_accountingdocitems-taxcode
          INTO TABLE @DATA(lt_taxcode_parameters).
        SORT lt_taxcode_parameters BY mwskz.

        LOOP AT it_accountingdocitems INTO DATA(ls_accountingdocitem_tax).
          IF ls_accountingdocitem_tax-amountintransactioncurrency IS INITIAL AND ls_accountingdocitem_tax-amountincompanycodecurrency IS NOT INITIAL.
            ls_accountingdocitem_tax-amountintransactioncurrency = ls_accountingdocitem_tax-amountincompanycodecurrency.
          ENDIF.
          IF ls_accountingdocitem_tax-debitcreditcode = 'S'.
            ls_accountingdocitem_tax-amountintransactioncurrency = ls_accountingdocitem_tax-amountintransactioncurrency * -1.
          ENDIF.
          DATA(lv_hkont) = COND hkont( WHEN ls_accountingdocitem_tax-alternativeglaccount IS NOT INITIAL THEN ls_accountingdocitem_tax-alternativeglaccount ELSE ls_accountingdocitem_tax-glaccount ).
          READ TABLE lt_account_parameters INTO DATA(ls_account_parameter) WITH KEY saknr = lv_hkont BINARY SEARCH.
          CHECK sy-subrc = 0.
          ls_edocument-fwste += ls_accountingdocitem_tax-amountintransactioncurrency.

          CHECK ls_accountingdocitem_tax-taxcode IS NOT INITIAL.
          READ TABLE lt_taxcode_parameters INTO DATA(ls_taxcode_parameter) WITH KEY mwskz = ls_accountingdocitem_tax-taxcode BINARY SEARCH.
          IF sy-subrc = 0.
            IF ls_edocument-invty IS INITIAL.
              ls_edocument-invty = ls_taxcode_parameter-invty.
            ENDIF.
            ls_edocument-taxex = ls_taxcode_parameter-taxex.
          ENDIF.
        ENDLOOP.
        IF ls_edocument-fwste IS INITIAL.
          ls_edocument-texex = abap_true.
        ENDIF.

        ls_invoice_rules_input-pidin = ls_edocument-prfid.
        ls_invoice_rules_input-ityin = ls_edocument-invty.

        CASE ls_edocument-prfid.
          WHEN 'EARSIV'.
            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_earchive_rule( iv_rule_type  = 'S'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-serpr = ls_invoice_rules_output-serpr.
            IF ls_edocument-serpr IS INITIAL.
              SELECT SINGLE serpr
                FROM zetr_t_easer
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND maisp = @abap_true
                INTO @ls_edocument-serpr.
            ENDIF.

            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_earchive_rule( iv_rule_type  = 'X'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-xsltt = ls_invoice_rules_output-xsltt.
            IF ls_edocument-xsltt IS INITIAL.
              SELECT SINGLE xsltt
                FROM zetr_t_eaxslt
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND deflt = @abap_true
                INTO @ls_edocument-xsltt.
            ENDIF.
          WHEN OTHERS.
            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_einvoice_rule( iv_rule_type  = 'S'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-serpr = ls_invoice_rules_output-serpr.
            IF ls_edocument-serpr IS INITIAL.
              DATA(lv_serial_type) = SWITCH zetr_e_insrt( ls_edocument-prfid WHEN 'IHRACAT' OR 'YOLCU' THEN ls_edocument-prfid ELSE 'YURTICI' ).
              SELECT SINGLE serpr
                FROM zetr_t_eiser
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND insrt = @lv_serial_type
                  AND maisp = @abap_true
                INTO @ls_edocument-serpr.
            ENDIF.

            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_einvoice_rule( iv_rule_type  = 'X'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-xsltt = ls_invoice_rules_output-xsltt.
            IF ls_edocument-xsltt IS INITIAL.
              SELECT SINGLE xsltt
                FROM zetr_t_eixslt
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND deflt = @abap_true
                INTO @ls_edocument-xsltt.
            ENDIF.
        ENDCASE.

        READ TABLE ct_accountingdocitemsout ASSIGNING FIELD-SYMBOL(<ls_accountingitemout>) WITH KEY rowindex = ls_accountingdocitem_partner-rowindex.
        IF sy-subrc = 0.
          <ls_accountingitemout>-einvoiceuuid = ls_edocument-docui.
          cv_substitutiondone = abap_true.
        ENDIF.

        INSERT zetr_t_oginv FROM @ls_edocument.
      WHEN 'H'.

    ENDCASE.
  ENDMETHOD.