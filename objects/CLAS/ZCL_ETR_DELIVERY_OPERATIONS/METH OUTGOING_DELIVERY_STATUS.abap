  METHOD outgoing_delivery_status.
    SELECT SINGLE bukrs, dlvii, sndus, dlvds, snddt,
                  stacd, staex, resst, radsc, rsend, envui, dlvui, dlvno, dlvqi, ruuid
      FROM zetr_t_ogdlv
      WHERE docui = @iv_document_uid
      INTO @DATA(ls_document).
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ELSEIF ls_document-stacd = ''.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e032(zetr_common).
    ELSEIF ( ls_document-resst <> '' AND
             ls_document-resst <> '0' AND
             ls_document-resst <> '1' ) OR ls_document-resst = 'R'.
      RETURN.
    ELSE.

      DATA(lo_edelivery_service) = zcl_etr_edelivery_ws=>factory( iv_company = ls_document-bukrs ).
      DATA(ls_ed_status) = lo_edelivery_service->outgoing_delivery_get_status( VALUE #( docui = iv_document_uid
                                                                                        docii = ls_document-dlvii
                                                                                        duich = ls_document-dlvui
                                                                                        docno = ls_document-dlvno
                                                                                        envui = ls_document-envui
                                                                                        ruuid = ls_document-ruuid ) ).
      MOVE-CORRESPONDING ls_ed_status TO rs_status.

      IF rs_status-stacd IS INITIAL.
        rs_status-stacd = ls_document-stacd.
      ENDIF.
      IF rs_status-dlvno IS INITIAL AND ls_document-dlvno IS NOT INITIAL.
        rs_status-dlvno = ls_document-dlvno.
      ENDIF.
      IF rs_status-dlvui IS INITIAL AND ls_document-dlvui IS NOT INITIAL.
        rs_status-dlvui = ls_document-dlvui.
      ENDIF.

      IF rs_status-resst = '1' AND rs_status-itmrs IS INITIAL.
        DATA(lv_response_ubl) = lo_edelivery_service->outgoing_delivery_respdown( is_document_numbers = VALUE #( docui = iv_document_uid
                                                                                                                 docii = ls_document-dlvii
                                                                                                                 duich = ls_document-dlvui
                                                                                                                 docno = ls_document-dlvno
                                                                                                                 envui = ls_document-envui
                                                                                                                 ruuid = rs_status-ruuid )
                                                                                  iv_content_type     = 'UBL' ).
        DATA(lv_delivery_ubl) = lo_edelivery_service->outgoing_delivery_download( is_document_numbers = VALUE #( docui = iv_document_uid
                                                                                                                 docii = ls_document-dlvii
                                                                                                                 duich = ls_document-dlvui
                                                                                                                 docno = ls_document-dlvno
                                                                                                                 envui = ls_document-envui
                                                                                                                 ruuid = rs_status-ruuid )
                                                                                  iv_content_type     = 'UBL' ).
        rs_status-itmrs = get_incoming_item_status_ubl( iv_response_ubl = lv_response_ubl
                                                        iv_delivery_ubl = lv_delivery_ubl ).
      ENDIF.

      IF rs_status-radsc IS NOT INITIAL AND rs_status-rsend IS INITIAL.
        SELECT SINGLE rsend
          FROM zetr_t_rasta
          WHERE radsc = @rs_status-radsc
          INTO @rs_status-rsend.
      ENDIF.

      CHECK iv_db_write = abap_true.
      UPDATE zetr_t_ogdlv
        SET stacd = @rs_status-stacd,
            staex = @rs_status-staex,
            resst = @rs_status-resst,
            radsc = @rs_status-radsc,
            rsend = @rs_status-rsend,
            envui = @rs_status-envui,
            dlvui = @rs_status-dlvui,
            dlvno = @rs_status-dlvno,
            dlvqi = @rs_status-dlvqi,
            ruuid = @rs_status-ruuid,
            itmrs = @rs_status-itmrs
        WHERE docui = @iv_document_uid.


      zcl_etr_regulative_log=>create_single_log(
        EXPORTING
          iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-status
          iv_document_id = iv_document_uid ).
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.