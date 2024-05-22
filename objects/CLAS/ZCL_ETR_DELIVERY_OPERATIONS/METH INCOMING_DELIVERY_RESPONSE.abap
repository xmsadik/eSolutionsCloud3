  METHOD incoming_delivery_response.
    SELECT SINGLE docui, bukrs, archv, dlvii AS docii, dlvui AS duich, dlvno AS docno, envui, ruuid
      FROM zetr_t_icdlv
      WHERE docui = @iv_document_uid
      INTO @DATA(ls_document).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ELSE.
      DATA(lo_edelivery_service) = zcl_etr_edelivery_ws=>factory( ls_document-bukrs ).
      lo_edelivery_service->incoming_delivery_response(
        is_document_numbers = CORRESPONDING #( ls_document )
        is_response_data    = is_response_data
        it_response_items   = it_response_items ).

      CHECK iv_commit_to_db = abap_true.
      zcl_etr_regulative_log=>create_single_log(
        EXPORTING
          iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-status
          iv_document_id = ls_document-docui ).
    ENDIF.
  ENDMETHOD.