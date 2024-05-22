  METHOD build_delivery_data.
    CASE ms_document-awtyp.
      WHEN 'BKPF' OR 'BKPFF'.
        build_delivery_data_bkpf( ).
      WHEN 'MKPF'.
        build_delivery_data_mkpf( ).
      WHEN 'LIKP'.
        build_delivery_data_likp( ).
    ENDCASE.

*    IF mv_barcode IS NOT INITIAL.
*      get_edelivery_barcode(
*      RECEIVING
*      iv_barcode = lv_barcode  ).
*      IF lv_barcode IS NOT INITIAL.
*        APPEND INITIAL LINE TO  ms_delivery_ubl-additional_document_reference ASSIGNING <ls_document_reference>.
*        <ls_document_reference>-id-content = ms_document-docui.
*        CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
*            INTO <ls_document_reference>-issue_date-content
*            SEPARATED BY '-'.
*        <ls_document_reference>-document_type-content = 'BARCODE'.
*        <ls_document_reference>-attachment-embedded_document_binary_objec-mime_code = 'image/jpeg'.
*        <ls_document_reference>-attachment-embedded_document_binary_objec-encoding_code = 'Base64'.
*        <ls_document_reference>-attachment-embedded_document_binary_objec-character_set_code = 'UTF-8'.
*        <ls_document_reference>-attachment-embedded_document_binary_objec-filename = 'barcode.jpeg'.
*        <ls_document_reference>-attachment-embedded_document_binary_objec-content = lv_barcode.
*      ENDIF.
*    ENDIF.

    delivery_abap_to_ubl( ).
    ev_delivery_hash = mv_delivery_hash.
    ev_delivery_ubl = mv_delivery_ubl.
    es_delivery_ubl = ms_delivery_ubl.
    et_custom_parameters[] = mt_custom_parameters[].
  ENDMETHOD.