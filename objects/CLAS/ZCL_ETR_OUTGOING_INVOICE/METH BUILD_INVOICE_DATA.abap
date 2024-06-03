  METHOD build_invoice_data.
    CASE ms_document-awtyp.
      WHEN 'BKPF' OR 'BKPFF'.
        build_invoice_data_bkpf( ).
      WHEN 'RMRP'.
        build_invoice_data_rmrp( ).
      WHEN 'VBRK'.
        build_invoice_data_vbrk( ).
    ENDCASE.

    CONDENSE: ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-content,
              ms_invoice_ubl-legalmonetarytotal-chargetotalamount-content,
              ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content,
              ms_invoice_ubl-legalmonetarytotal-payableamount-content,
              ms_invoice_ubl-legalmonetarytotal-payableroundingamount-content,
              ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-content,
              ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content.
    LOOP AT ms_invoice_ubl-taxtotal ASSIGNING FIELD-SYMBOL(<ls_taxtotal>).
      CONDENSE: <ls_taxtotal>-taxamount-content.
      LOOP AT <ls_taxtotal>-taxsubtotal ASSIGNING FIELD-SYMBOL(<ls_taxsubtotal>).
        CONDENSE: <ls_taxsubtotal>-taxamount-content,
                  <ls_taxsubtotal>-taxableamount-content,
                  <ls_taxsubtotal>-perunitamount-content,
                  <ls_taxsubtotal>-percent-content.
      ENDLOOP.
    ENDLOOP.
    LOOP AT ms_invoice_ubl-withholdingtaxtotal ASSIGNING <ls_taxtotal>.
      CONDENSE: <ls_taxtotal>-taxamount-content.
      LOOP AT <ls_taxtotal>-taxsubtotal ASSIGNING <ls_taxsubtotal>.
        CONDENSE: <ls_taxsubtotal>-taxamount-content,
                  <ls_taxsubtotal>-taxableamount-content,
                  <ls_taxsubtotal>-perunitamount-content,
                  <ls_taxsubtotal>-percent-content.
      ENDLOOP.
    ENDLOOP.

    LOOP AT ms_invoice_ubl-invoiceline ASSIGNING FIELD-SYMBOL(<ls_invoice_line>).
      CONDENSE: <ls_invoice_line>-taxtotal-taxamount-content.
      LOOP AT <ls_invoice_line>-taxtotal-taxsubtotal ASSIGNING <ls_taxsubtotal>.
        CONDENSE: <ls_taxsubtotal>-taxamount-content,
                  <ls_taxsubtotal>-taxableamount-content,
                  <ls_taxsubtotal>-perunitamount-content,
                  <ls_taxsubtotal>-percent-content.
      ENDLOOP.
      LOOP AT <ls_invoice_line>-withholdingtaxtotal ASSIGNING <ls_taxtotal>.
        CONDENSE: <ls_taxtotal>-taxamount-content.
        LOOP AT <ls_taxtotal>-taxsubtotal ASSIGNING <ls_taxsubtotal>.
          CONDENSE: <ls_taxsubtotal>-taxamount-content,
                    <ls_taxsubtotal>-taxableamount-content,
                    <ls_taxsubtotal>-perunitamount-content,
                    <ls_taxsubtotal>-percent-content.
        ENDLOOP.
      ENDLOOP.

      CONDENSE: <ls_invoice_line>-price-priceamount-content,
                <ls_invoice_line>-lineextensionamount-content,
                <ls_invoice_line>-invoicedquantity-content.

      LOOP AT <ls_invoice_line>-allowancecharge ASSIGNING FIELD-SYMBOL(<ls_allowance_charge>).
        CONDENSE: <ls_allowance_charge>-amount-content,
                  <ls_allowance_charge>-baseamount-content,
                  <ls_allowance_charge>-multiplierfactornumeric-content.
      ENDLOOP.
    ENDLOOP.

*    IF mv_barcode IS NOT INITIAL.
*      IF ms_document-prfid NE 'EARSIV'.
*        get_einvoice_barcode(
*        RECEIVING
*        iv_barcode = lv_barcode ).
*      ELSE.
*        get_earchive_barcode(
*        RECEIVING
*        iv_barcode = lv_barcode ).
*      ENDIF.
*      IF lv_barcode IS NOT INITIAL.
*        APPEND INITIAL LINE TO ms_invoice_ubl-additional_document_reference ASSIGNING <ls_document_reference>.
*        <ls_document_reference>-id-content = ms_document-docui.
*        CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
*          INTO <ls_document_reference>-issuedate-content
*          SEPARATED BY '-'.
*        <ls_document_reference>-document_type-content = 'BARCODE'.
*        <ls_document_reference>-attachment-embeddeddocumentbinaryobjec-mime_code = 'image/jpeg'.
*        <ls_document_reference>-attachment-embeddeddocumentbinaryobjec-encoding_code = 'Base64'.
*        <ls_document_reference>-attachment-embeddeddocumentbinaryobjec-character_set_code = 'UTF-8'.
*        <ls_document_reference>-attachment-embeddeddocumentbinaryobjec-filename = 'barcode.jpeg'.
*        <ls_document_reference>-attachment-embeddeddocumentbinaryobjec-content = lv_barcode.
*      ENDIF.
*    ENDIF.

    IF ms_invoice_ubl-profileid-content IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e021(zetr_common).
    ENDIF.

    IF ms_invoice_ubl-invoicetypecode-content IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e022(zetr_common).
    ENDIF.

    IF ms_invoice_ubl-taxtotal IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e057(zetr_common).
    ENDIF.

    IF ms_invoice_ubl-profileid-content = 'IHRACAT'.
      READ TABLE ms_invoice_ubl-delivery INTO DATA(ls_delivery) INDEX 1.
      IF sy-subrc IS INITIAL.
        DATA(lv_export_data) = abap_true.
        IF ls_delivery-deliveryaddress IS INITIAL.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e203(zetr_common).
        ENDIF.

        READ TABLE ls_delivery-deliveryterms INTO DATA(ls_delivery_terms) INDEX 1.
        IF sy-subrc IS NOT INITIAL OR ls_delivery_terms-id-content IS INITIAL.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e204(zetr_common).
        ENDIF.
      ENDIF.

      LOOP AT ms_invoice_ubl-invoiceline INTO DATA(ls_invoice_line).
        READ TABLE ls_invoice_line-delivery INTO ls_delivery INDEX 1.
        IF lv_export_data IS INITIAL.
          IF sy-subrc IS NOT INITIAL OR ls_delivery-deliveryaddress IS INITIAL.
            RAISE EXCEPTION TYPE zcx_etr_regulative_exception
              MESSAGE e203(zetr_common).
          ENDIF.

          READ TABLE ls_delivery-shipment-shipmentstage INTO DATA(ls_shipment_stage) INDEX 1.
          IF sy-subrc IS NOT INITIAL OR ls_shipment_stage-transportmodecode-content IS INITIAL.
            RAISE EXCEPTION TYPE zcx_etr_regulative_exception
              MESSAGE e205(zetr_common).
          ENDIF.

          READ TABLE ls_delivery-deliveryterms INTO ls_delivery_terms INDEX 1.
          IF sy-subrc IS NOT INITIAL OR ls_delivery_terms-id-content IS INITIAL.
            RAISE EXCEPTION TYPE zcx_etr_regulative_exception
              MESSAGE e204(zetr_common).
          ENDIF.
        ENDIF.

        READ TABLE ls_delivery-shipment-goodsitem INTO DATA(ls_goods_item) INDEX 1.
        IF sy-subrc IS NOT INITIAL OR ls_goods_item-requiredcustomsid-content IS INITIAL.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e206(zetr_common) WITH ls_invoice_line-item-sellersitemidentification-id-content && ` ` &&
                                           ls_invoice_line-item-name-content.
        ENDIF.
      ENDLOOP.
    ENDIF.

    LOOP AT ms_invoice_ubl-invoiceline INTO ls_invoice_line.
      DATA(lv_tabix) = sy-tabix.
      IF ls_invoice_line-lineextensionamount-content < 0.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e077(zetr_common) WITH TEXT-005.
      ENDIF.
      LOOP AT ls_invoice_line-allowancecharge INTO DATA(ls_allowance_charge).
        IF ls_allowance_charge-amount-content < 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e077(zetr_common) WITH TEXT-006.
        ENDIF.
      ENDLOOP.

      IF ls_invoice_line-taxtotal-taxamount-content < 0.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e077(zetr_common) WITH TEXT-007.
      ENDIF.
      LOOP AT ls_invoice_line-taxtotal-taxsubtotal INTO DATA(ls_taxsubtotal).
        IF ls_taxsubtotal-taxableamount-content < 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e077(zetr_common) WITH TEXT-008.
        ENDIF.

        IF ls_taxsubtotal-taxamount-content < 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e077(zetr_common) WITH TEXT-009.
        ENDIF.
      ENDLOOP.

      IF ls_invoice_line-price-priceamount-content < 0.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e077(zetr_common) WITH TEXT-010.
      ENDIF.
    ENDLOOP.

    IF ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-011.
    ENDIF.

    IF ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-012.
    ENDIF.

    IF ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-013.
    ENDIF.

    IF ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-014.
    ENDIF.

    IF ms_invoice_ubl-legalmonetarytotal-chargetotalamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-015.
    ENDIF.

    IF ms_invoice_ubl-legalmonetarytotal-payableroundingamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-016.
    ENDIF.

    IF ms_invoice_ubl-legalmonetarytotal-payableamount-content < 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e076(zetr_common) WITH TEXT-017.
    ENDIF.

    LOOP AT ms_invoice_ubl-taxtotal INTO DATA(ls_taxtotal).
      IF ls_taxtotal-taxamount-content < 0.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e076(zetr_common) WITH TEXT-018.
      ENDIF.

      LOOP AT ls_taxtotal-taxsubtotal INTO ls_taxsubtotal.
        IF ls_taxsubtotal-taxableamount-content < 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e076(zetr_common) WITH TEXT-019.
        ENDIF.

        IF ls_taxsubtotal-taxamount-content < 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e076(zetr_common) WITH TEXT-020.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    invoice_abap_to_ubl( ).
    ev_invoice_hash = mv_invoice_hash.
    ev_invoice_ubl = mv_invoice_ubl.
    es_invoice_ubl = ms_invoice_ubl.
    et_custom_parameters[] = mt_custom_parameters[].
  ENDMETHOD.