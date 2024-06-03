  METHOD fill_common_invoice_data.
    ms_invoice_ubl-ublversionid-content = '2.1'.
    ms_invoice_ubl-customizationid-content = 'TR1.2.1'.
    ms_invoice_ubl-copyindicator-content = 'false'.
    DATA(lv_syuzeit) = cl_abap_context_info=>get_system_time( ).
    ms_invoice_ubl-issuetime-content = lv_syuzeit+0(2) && ':' &&
                                       lv_syuzeit+2(2) && ':' &&
                                       lv_syuzeit+4(2).
    ms_invoice_ubl-profileid-content = zcl_etr_invoice_operations=>conversion_profile_id_output( CONV #( ms_document-prfid ) ).
    ms_invoice_ubl-invoicetypecode-content = zcl_etr_invoice_operations=>conversion_profile_id_output( CONV #( ms_document-invty ) ).
    ms_invoice_ubl-uuid-content = ms_document-invui.

    ms_invoice_ubl-accountingsupplierparty-party = ubl_fill_company_data( iv_bukrs = ms_document-bukrs ).
    READ TABLE ms_invoice_ubl-accountingsupplierparty-party-partyidentification
      WITH KEY schemeid = 'VKN'
      TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO ms_invoice_ubl-accountingsupplierparty-party-partyidentification ASSIGNING FIELD-SYMBOL(<ls_party_identification>).
      <ls_party_identification>-schemeid = 'VKN'.
      <ls_party_identification>-content = mv_company_taxid.
    ENDIF.

    IF mv_add_signature IS NOT INITIAL.
      APPEND INITIAL LINE TO ms_invoice_ubl-signature ASSIGNING FIELD-SYMBOL(<ls_signature>).
      <ls_signature>-id-schemeid = 'VKN_TCKN'.
      <ls_signature>-id-content = mv_company_taxid.
      <ls_signature>-signatoryparty = ms_invoice_ubl-accountingsupplierparty-party.
    ENDIF.

    IF mv_preview IS INITIAL AND mv_generate_invoice_id IS NOT INITIAL AND ms_document-invno IS INITIAL.
      IF ms_document-serpr IS INITIAL.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e029(zetr_common).
      ENDIF.
      generate_invoice_id( ).
      ms_invoice_ubl-id-content = ms_document-invno.
    ELSEIF mv_generate_invoice_id IS NOT INITIAL AND ms_document-invno IS NOT INITIAL.
      ms_invoice_ubl-id-content = ms_document-invno.
    ENDIF.
    IF ms_document-prfid = 'IHRACAT'.
      APPEND INITIAL LINE TO ms_invoice_ubl-paymentmeans ASSIGNING FIELD-SYMBOL(<ls_payment_means>).
      <ls_payment_means>-paymentmeanscode-content = 'ZZZ'.
      <ls_payment_means>-paymentduedate-content = ms_invoice_ubl-paymentterms-paymentduedate-content.

      SELECT SINGLE value
        FROM zetr_t_cmppi
        WHERE bukrs = @ms_document-bukrs
          AND prtid = 'IBAN'
        INTO @<ls_payment_means>-payeefinancialaccount-id-content.
      SELECT SINGLE value
        FROM zetr_t_cmppi
        WHERE bukrs = @ms_document-bukrs
          AND prtid = 'PARA_BIRIM'
        INTO @<ls_payment_means>-payeefinancialaccount-currencycode-content.
    ENDIF.

*    IF ms_document-prfid EQ 'KAMU'.
*      READ TABLE ms_invoice_ubl-accountingcustomerparty-party-partyidentification INTO DATA(ls_identification) WITH KEY schemeid = 'VKN'.
*      IF sy-subrc EQ 0.
*        DATA(lv_taxid) = ls_identification-content.
*      ELSE.
*        READ TABLE ms_invoice_ubl-accountingcustomerparty-party-partyidentification INTO ls_identification WITH KEY schemeid = 'TCKN'.
*        IF sy-subrc EQ 0.
*          lv_taxid = ls_identification-content.
*        ENDIF.
*      ENDIF.
*      SELECT SINGLE *
*        FROM /itetr/inv_eipi
*        INTO ls_eipi
*       WHERE taxid = lv_taxid.
*      IF ls_eipi-kunnr IS INITIAL.
*        ms_invoice_ubl-buyer_customer_party = ms_invoice_ubl-accountingcustomerparty.
*      ELSE.
*        mo_invoice_operations->get_customer_taxid(
*          EXPORTING
*            iv_kunnr      = ls_eipi-kunnr
*          IMPORTING
*            ev_taxid      = lv_taxid
*            ev_tax_office = lv_tax_office
*            ev_adrnr      = lv_adrnr ).
*        ms_invoice_ubl-buyer_customer_party-party = ubl_fill_partner_data( iv_address_number = lv_adrnr
*                                                                                 iv_tax_office     = lv_tax_office
*                                                                                 iv_tax_id         = lv_taxid
*                                                                                 iv_profile_id     = ms_document-prfid ).
*      ENDIF.
*
*      IF ls_eipi-iban IS INITIAL.
*        lx_etr_exception = zcx_etr_regulative_exception=>create_by_message( '098' ).
*        RAISE EXCEPTION lx_etr_exception.
*      ENDIF.
*      APPEND INITIAL LINE TO ms_invoice_ubl-payment_means ASSIGNING <ls_payment_means>.
*      <ls_payment_means>-payment_means_code-content = ls_eipi-payment.
*      <ls_payment_means>-payee_financial_account-id-content = ls_eipi-iban.
*      <ls_payment_means>-payee_financial_account-currency_code-content = ms_invoice_ubl-documentcurrencycode-content.
*    ENDIF.

    IF ms_document-inote IS NOT INITIAL.
      SPLIT ms_document-inote AT '*' INTO TABLE DATA(lt_notes).
      IF lt_notes IS NOT INITIAL.
        LOOP AT lt_notes INTO DATA(ls_note).
          APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING FIELD-SYMBOL(<ls_invoice_note>).
          <ls_invoice_note>-content = ls_note.
        ENDLOOP.
      ELSE.
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-content = ms_document-inote.
      ENDIF.
    ENDIF.

    IF ms_document-xsltt IS NOT INITIAL.
*      cl_o2_api_xsltdesc=>load(
*        EXPORTING
*          p_xslt_desc                  = ms_document-xsltt
*          p_gen_flag                   = abap_true
*        IMPORTING
*          p_obj = DATA(lo_xslt_obj)
*        EXCEPTIONS
*          error_occured                = 1
*          not_existing                 = 2
*          permission_failure           = 3
*          version_not_found            = 4
*          OTHERS                       = 5 ).
      SELECT SINGLE xsltc
        FROM zetr_t_eixslt
        WHERE bukrs = @ms_document-bukrs
          AND xsltt = @ms_document-xsltt
        INTO @DATA(lv_xslt_source).
      IF sy-subrc IS INITIAL AND lv_xslt_source IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-additionaldocumentreference ASSIGNING FIELD-SYMBOL(<ls_document_reference>).
        <ls_document_reference>-id-content = ms_document-docui.
        DATA(lv_sydatum) = cl_abap_context_info=>get_system_date( ).
        CONCATENATE lv_sydatum(4) lv_sydatum+4(2) lv_sydatum+6(2)
          INTO <ls_document_reference>-issuedate-content
          SEPARATED BY '-'.
        <ls_document_reference>-documenttype-content = 'XSLT'.
        <ls_document_reference>-attachment-embeddeddocumentbinaryobject-mimecode = 'application/xml'.
        <ls_document_reference>-attachment-embeddeddocumentbinaryobject-encodingcode = 'Base64'.
        <ls_document_reference>-attachment-embeddeddocumentbinaryobject-charactersetcode = 'UTF-8'.
        CONCATENATE ms_document-xsltt '.xslt' INTO <ls_document_reference>-attachment-embeddeddocumentbinaryobject-filename.
        <ls_document_reference>-attachment-embeddeddocumentbinaryobject-content = xco_cp=>xstring(  lv_xslt_source )->as_string( xco_cp_binary=>text_encoding->base64 )->value.
      ENDIF.
    ENDIF.

    DATA(lv_payableamount) = CONV wrbtr_cs( ms_invoice_ubl-legalmonetarytotal-payableamount-content ).
    DATA(lv_words) = zcl_etr_regulative_common=>amount_to_words( amount = lv_payableamount currency = ms_invoice_ubl-documentcurrencycode-content  ).
    APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
    CONCATENATE 'Yalnızca' ` ` lv_words INTO <ls_invoice_note>-content.

*    lv_currency = ms_invoice_ubl-legalmonetarytotal-payableamount-currencyid.
*    CASE lv_currency.
*      WHEN 'TRY'.
*        lv_currency_text = 'TL'.
*        lv_cent_text = 'KURUŞ'.
*      WHEN OTHERS.
*        lv_currency_text = lv_currency.
*        lv_cent_text = 'CENT'.
*    ENDCASE.
*    CALL FUNCTION 'SPELL_AMOUNT'
*      EXPORTING
*        amount    = lv_payableamount
*        currency  = lv_currency
*        language  = sy-langu
*      IMPORTING
*        in_words  = ls_amount_in_words
*      EXCEPTIONS
*        not_found = 1
*        too_large = 2
*        OTHERS    = 3.
*    IF sy-subrc IS INITIAL.
*      APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
*      CONCATENATE 'YAZI İLE' ` ` ls_amount_in_words-word ` ` lv_currency_text INTO <ls_invoice_note>-content.
*      IF ls_amount_in_words-decimal IS NOT INITIAL.
*        CONCATENATE <ls_invoice_note>-content ` ` ls_amount_in_words-decword ` ` lv_cent_text INTO <ls_invoice_note>-content.
*      ENDIF.
*    ENDIF.
*    DATA lv_wrbtr_cs_try TYPE wrbtr_cs .
*    IF ms_document-prfid EQ 'EARSIV' " TRY dışı kesilen faturaların TRY Dönüşümü
*      OR ms_document-prfid EQ  'TEMEL'
*      OR  ms_document-prfid EQ 'TICARI'.
*      IF lv_currency NE 'TRY'.
*        lv_wrbtr_cs_try =   ms_document-kursf * ms_document-wrbtr .
*        CALL FUNCTION 'SPELL_AMOUNT'
*          EXPORTING
*            amount    = lv_wrbtr_cs_try
*            currency  = 'TRY'
*            language  = sy-langu
*          IMPORTING
*            in_words  = ls_amount_in_words
*          EXCEPTIONS
*            not_found = 1
*            too_large = 2
*            OTHERS    = 3.
*        IF sy-subrc IS INITIAL.
*          APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
*          CONCATENATE 'YAZI İLE' ` ` ls_amount_in_words-word ` ` 'TL' INTO <ls_invoice_note>-content.
*          IF ls_amount_in_words-decimal IS NOT INITIAL.
*            CONCATENATE <ls_invoice_note>-content ` ` ls_amount_in_words-decword ` ` 'KURUŞ' INTO <ls_invoice_note>-content.
*          ENDIF.
*        ENDIF.
*
*      ENDIF.
*    ENDIF.

    ms_invoice_ubl-linecountnumeric-content = lines( ms_invoice_ubl-invoiceline ).

    IF ms_document-prfid = 'EARSIV'.
      IF ms_document-intsl IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-content = TEXT-001.
      ENDIF.
      IF ms_document-eatyp IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        CONCATENATE TEXT-002 ms_document-eatyp INTO <ls_invoice_note>-content.
      ELSEIF ms_invoice_ubl-accountingcustomerparty-party-contact-electronicmail-content IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-content = TEXT-003.
      ELSE.
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-content = TEXT-004.
      ENDIF.

      IF ms_invoice_ubl-accountingcustomerparty-party-contact-electronicmail-content IS NOT INITIAL.
        APPEND INITIAL LINE TO mt_custom_parameters ASSIGNING FIELD-SYMBOL(<ls_custom_parameter>).
        <ls_custom_parameter>-cuspa = 'MAIL'.
        <ls_custom_parameter>-value = ms_invoice_ubl-accountingcustomerparty-party-contact-electronicmail-content.
      ENDIF.

      IF ms_invoice_ubl-accountingcustomerparty-party-contact-telephone-content IS NOT INITIAL.
        APPEND INITIAL LINE TO mt_custom_parameters ASSIGNING <ls_custom_parameter>.
        <ls_custom_parameter>-cuspa = 'TEL'.
        <ls_custom_parameter>-value = ms_invoice_ubl-accountingcustomerparty-party-contact-telephone-content.
      ENDIF.
    ENDIF.
  ENDMETHOD.