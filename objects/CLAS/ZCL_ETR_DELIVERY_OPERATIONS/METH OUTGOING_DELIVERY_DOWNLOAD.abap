  METHOD outgoing_delivery_download.
    SELECT SINGLE docui, bukrs, archv, dlvii AS docii, dlvui AS duich, dlvno AS docno, envui, ruuid, stacd
      FROM zetr_t_ogdlv
      WHERE docui = @iv_document_uid
      INTO @DATA(ls_document).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
*    ELSEIF ls_document-stacd = '' OR ls_document-stacd = '2'.
*      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
*        MESSAGE e032(zetr_common).
    ELSEIF ls_document-archv IS NOT INITIAL.
      SELECT SINGLE contn
        FROM zetr_t_arcd
        WHERE docui = @ls_document-docui
          AND conty = @iv_content_type
          AND docty = 'OUTDLVDOC'
        INTO @rv_delivery_data.
    ELSE.
      CASE ls_document-stacd.
        WHEN '' OR '2'.
          DATA(OutgoingDeliveryInstance) = zcl_etr_outgoing_delivery=>factory( iv_document_uuid = ls_document-docui
                                                                               iv_preview = abap_true ).
          OutgoingDeliveryInstance->build_delivery_data(
            IMPORTING
              es_delivery_ubl       = DATA(ls_delivery_ubl)
              ev_delivery_ubl       = DATA(lv_delivery_ubl)
              ev_delivery_hash      = DATA(lv_delivery_hash)
              et_custom_parameters  = DATA(lt_custom_parameters) ).
          CASE iv_content_type.
            WHEN 'UBL'.
              rv_delivery_data = lv_delivery_ubl.
            WHEN OTHERS.
              rv_delivery_data = outgoing_delivery_preview( iv_document_uid = iv_document_uid
                                                            iv_content_type = iv_content_type
                                                            iv_document_ubl = lv_delivery_ubl ).
          ENDCASE.
        WHEN OTHERS.
          DATA(lo_edelivery_service) = zcl_etr_edelivery_ws=>factory( iv_company = ls_document-bukrs ).
          rv_delivery_data = lo_edelivery_service->outgoing_delivery_download( is_document_numbers = CORRESPONDING #( ls_document )
                                                                               iv_content_type = iv_content_type ).
      ENDCASE.
      CHECK iv_db_write = abap_true.
      zcl_etr_regulative_log=>create_single_log(
        EXPORTING
          iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-download
          iv_document_id = ls_document-docui ).
    ENDIF.
  ENDMETHOD.