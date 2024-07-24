  METHOD outgoing_invoice_status.
    SELECT SINGLE i~docui, i~bukrs, i~invii, i~invui, i~invno, i~envui, i~stacd,
                  i~staex, i~prfid, i~resst, r~rsend, i~belnr, i~gjahr, i~taxid,
                  i~sndus, i~radsc, i~inids, i~snddt, i~rprid, i~raded, i~cedrn, i~radrn
      FROM zetr_t_oginv AS i
      LEFT OUTER JOIN zetr_t_rasta AS r
        ON r~radsc = i~radsc
      WHERE docui = @iv_document_uid
      INTO @DATA(ls_document).
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ELSEIF ls_document-stacd = ''.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e032(zetr_common).
    ELSE.
      CASE ls_document-prfid.
        WHEN 'EARSIV'.
          DATA(lo_earchive_service) = zcl_etr_earchive_ws=>factory( iv_company = ls_document-bukrs ).
          DATA(ls_earchive_status) = lo_earchive_service->outgoing_invoice_get_status( is_document_numbers = VALUE #( docui = ls_document-docui
                                                                                                                      docii = ls_document-invii
                                                                                                                      duich = ls_document-invui
                                                                                                                      docno = ls_document-invno
                                                                                                                 envui = ls_document-envui ) ).
          rs_status = CORRESPONDING #( ls_earchive_status ).
        WHEN OTHERS.
          DATA(lo_einvoice_service) = zcl_etr_einvoice_ws=>factory( iv_company = ls_document-bukrs ).
          DATA(ls_einvoice_status) = lo_einvoice_service->outgoing_invoice_get_status( is_document_numbers = VALUE #( docui = ls_document-docui
                                                                                                                      docii = ls_document-invii
                                                                                                                      duich = ls_document-invui
                                                                                                                      docno = ls_document-invno
                                                                                                                 envui = ls_document-envui ) ).
          rs_status = CORRESPONDING #( ls_einvoice_status ).
      ENDCASE.

      IF rs_status-stacd IS INITIAL.
        rs_status-stacd = ls_document-stacd.
      ELSEIF rs_status-stacd = '2'.
        CLEAR rs_status-resst.
      ENDIF.
      IF rs_status-invno IS INITIAL AND ls_document-invno IS NOT INITIAL.
        rs_status-invno = ls_document-invno.
      ENDIF.
      IF rs_status-invui IS INITIAL AND ls_document-invui IS NOT INITIAL.
        rs_status-invui = ls_document-invui.
      ENDIF.
      IF rs_status-invii IS INITIAL AND ls_document-invii IS NOT INITIAL.
        rs_status-invii = ls_document-invii.
      ENDIF.
      IF rs_status-resst IS INITIAL.
        CASE ls_document-prfid.
          WHEN 'TEMEL' OR 'EARSIV'.
            rs_status-resst = 'X'.
          WHEN OTHERS.
            rs_status-resst = '0'.
        ENDCASE.
      ENDIF.

      IF rs_status-resst = '0' AND rs_status-rsend IS INITIAL.
        DATA lv_difference TYPE i.
        lv_difference = cl_abap_context_info=>get_system_date( ) - ls_document-snddt.
        IF lv_difference GT 8.
          rs_status-resst = '2'.
        ENDIF.
      ENDIF.

      IF rs_status-radsc IS NOT INITIAL AND rs_status-rsend IS INITIAL.
        rs_status-rsend = ls_document-rsend.
      ENDIF.

      CHECK iv_db_write = abap_true.
      UPDATE zetr_t_oginv
        SET stacd = @rs_status-stacd,
            staex = @rs_status-staex,
            resst = @rs_status-resst,
            radsc = @rs_status-radsc,
            rsend = @rs_status-rsend,
            raded = @rs_status-raded,
            cedrn = @rs_status-cedrn,
            radrn = @rs_status-radrn,
            invno = @rs_status-invno,
            invui = @rs_status-invui,
            rprid = @rs_status-rprid,
            envui = @rs_status-envui,
            invii = @rs_status-invii
        WHERE docui = @iv_document_uid.

      zcl_etr_regulative_log=>create_single_log(
        EXPORTING
          iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-status
          iv_document_id = ls_document-docui ).

      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.