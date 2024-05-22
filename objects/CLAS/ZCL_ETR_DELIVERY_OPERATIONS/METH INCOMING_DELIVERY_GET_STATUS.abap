  METHOD incoming_delivery_get_status.
    SELECT SINGLE docui, bukrs, archv, dlvii AS docii, dlvui AS duich, dlvno AS docno, envui, ruuid
      FROM zetr_t_icdlv
      WHERE docui = @iv_document_uid
      INTO @DATA(ls_document).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ELSE.
      DATA(lo_edelivery_service) = zcl_etr_edelivery_ws=>factory( ls_document-bukrs ).
      rs_status = lo_edelivery_service->incoming_delivery_get_status( CORRESPONDING #( ls_document ) ).

      IF rs_status-itmrs IS INITIAL.
        DATA: lv_reject  TYPE abap_boolean,
              lv_partial TYPE abap_boolean.
        SELECT linno, menge, meins, recqt, napqt, misqt, ovsqt
          FROM zetr_t_icdli
          WHERE docui = @iv_document_uid
          INTO TABLE @DATA(lt_items).
        DELETE lt_items WHERE recqt IS INITIAL.
        IF lt_items IS NOT INITIAL.
          LOOP AT lt_items INTO DATA(ls_item).
            IF ls_item-napqt IS NOT INITIAL AND ls_item-menge = ls_item-napqt.
              lv_reject = abap_true.
            ELSEIF ls_item-napqt IS NOT INITIAL AND ls_item-menge <> ls_item-napqt.
              lv_partial = abap_true.
            ENDIF.
          ENDLOOP.
          IF lv_reject = abap_true AND lv_partial = abap_true.
            rs_status-itmrs = 'M'.
          ELSEIF lv_reject = abap_true AND lv_partial = abap_false.
            rs_status-itmrs = 'R'.
          ELSEIF lv_reject = abap_false AND lv_partial = abap_true.
            rs_status-itmrs = 'P'.
          ELSE.
            rs_status-itmrs = 'A'.
          ENDIF.
        ENDIF.
      ENDIF.

      CHECK iv_commit_to_db = abap_true.

      UPDATE zetr_t_icdlv
        SET resst = @rs_status-resst,
            staex = @rs_status-staex,
            itmrs = @rs_status-itmrs,
            radsc = @rs_status-radsc,
            ruuid = @rs_status-ruuid
        WHERE docui = @iv_document_uid.

      IF rs_status-ruuid IS NOT INITIAL.
        SELECT *
          FROM zetr_t_arcd
          WHERE docui = @iv_document_uid
            AND docty = 'INCDLVRES'
          INTO TABLE @DATA(lt_archive).
        IF sy-subrc <> 0.
          zcl_etr_regulative_archive=>create( it_archives = VALUE #( ( docui = iv_document_uid
                                                                       conty = 'PDF'
                                                                       docty = 'INCDLVRES' )
                                                                      ( docui = iv_document_uid
                                                                       conty = 'HTML'
                                                                       docty = 'INCDLVRES' )
                                                                      ( docui = iv_document_uid
                                                                       conty = 'UBL'
                                                                       docty = 'INCDLVRES' ) ) ).
        ENDIF.
      ENDIF.

      zcl_etr_regulative_log=>create_single_log(
        EXPORTING
          iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-status
          iv_document_id = ls_document-docui ).
    ENDIF.
  ENDMETHOD.