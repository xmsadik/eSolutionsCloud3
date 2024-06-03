  METHOD fill_common_delivery_data.
*    DATA: lv_payable_amount  TYPE wrbtr_cs,
*          lv_currency        TYPE waers,
*          lv_currency_text   TYPE c LENGTH 5,
*          lv_cent_text       TYPE c LENGTH 5,
*          lv_xslt_raw        TYPE string,
*          lcl_descr_ref      TYPE REF TO cl_abap_typedescr.
*    FIELD-SYMBOLS: <ls_party_identification> TYPE /itetr/com_party_identificati1,
*                   <ls_signature>            TYPE /itetr/com_signature,
*                   <ls_delivery_note>        TYPE /itetr/com_note,
*                   <ls_document_reference>   TYPE /itetr/com_additional_document,
*                   <ls_custom_parameter>     TYPE /itetr/com_s_custom_param,
*                   <ls_payment_means>        TYPE /itetr/com_payment_means.

    ms_delivery_ubl-ublversionid-content = '2.1'.
    ms_delivery_ubl-customizationid-content = 'TR1.2.1'.
    ms_delivery_ubl-copyindicator-content = 'false'.
    ms_delivery_ubl-profileid-content = SWITCH #( ms_document-prfid WHEN 'TEMEL' THEN ms_document-prfid && 'IRSALIYE' ELSE ms_document-prfid ).
    ms_delivery_ubl-despatchadvicetypecode-content = ms_document-dlvty.
    ms_delivery_ubl-uuid-content = ms_document-dlvui.

    ms_delivery_ubl-despatchsupplierparty-party = ubl_fill_company_data( iv_bukrs = ms_document-bukrs ).
    READ TABLE ms_delivery_ubl-despatchsupplierparty-party-partyidentification
      WITH KEY schemeid = 'VKN'
      TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO ms_delivery_ubl-despatchsupplierparty-party-partyidentification ASSIGNING FIELD-SYMBOL(<ls_party_identification>).
      <ls_party_identification>-schemeid = 'VKN'.
      <ls_party_identification>-content = mv_company_taxid.
    ENDIF.

    IF mv_add_signature IS NOT INITIAL.
      APPEND INITIAL LINE TO ms_delivery_ubl-signature ASSIGNING FIELD-SYMBOL(<ls_signature>).
      <ls_signature>-id-schemeid = 'VKN_TCKN'.
      <ls_signature>-id-content = mv_company_taxid.
      <ls_signature>-signatoryparty = ms_delivery_ubl-despatchsupplierparty-party.
    ENDIF.

    IF mv_preview IS INITIAL AND ms_company_parameters-genid IS NOT INITIAL AND ms_document-dlvno IS INITIAL.
      IF ms_document-serpr IS INITIAL.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e029(zetr_common).
      ENDIF.
      generate_delivery_id( ).
      ms_delivery_ubl-id-content = ms_document-dlvno.
    ELSEIF ms_company_parameters-genid IS NOT INITIAL AND ms_document-dlvno IS NOT INITIAL.
      ms_delivery_ubl-id-content = ms_document-dlvno.
    ENDIF.

    IF ms_document-dnote IS NOT INITIAL.
      SPLIT ms_document-dnote AT '*' INTO TABLE DATA(lt_notes).
      IF lt_notes IS NOT INITIAL.
        LOOP AT lt_notes INTO DATA(ls_note).
          APPEND INITIAL LINE TO ms_delivery_ubl-note ASSIGNING FIELD-SYMBOL(<ls_delivery_note>).
          <ls_delivery_note>-content = ls_note.
        ENDLOOP.
      ELSE.
        APPEND INITIAL LINE TO ms_delivery_ubl-note ASSIGNING <ls_delivery_note>.
        <ls_delivery_note>-content = ms_document-dnote.
      ENDIF.
    ENDIF.

    IF ms_document-xsltt IS NOT INITIAL.
      SELECT SINGLE xsltc
        FROM zetr_t_edxslt
        WHERE bukrs = @ms_document-bukrs
          AND xsltt = @ms_document-xsltt
        INTO @DATA(lv_xslt_source).
      IF sy-subrc IS INITIAL AND lv_xslt_source IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_delivery_ubl-additionaldocumentreference ASSIGNING FIELD-SYMBOL(<ls_document_reference>).
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

    IF ms_document-dlvty = 'MATBUDAN'.
      APPEND INITIAL LINE TO ms_delivery_ubl-additionaldocumentreference ASSIGNING <ls_document_reference>.
      <ls_document_reference>-id-content = ms_document-pdnum.
      CONCATENATE ms_document-pddat(4) ms_document-pddat+4(2) ms_document-pddat+6(2)
        INTO <ls_document_reference>-issuedate-content
        SEPARATED BY '-'.
      <ls_document_reference>-documenttype-content = 'MATBU'.
    ENDIF.

    ms_delivery_ubl-linecountnumeric-content = lines( ms_delivery_ubl-despatchline ).
  ENDMETHOD.