  METHOD outgoing_delivery_save.
    SELECT COUNT(*)
     FROM zetr_t_ogdlv
     WHERE awtyp EQ @iv_awtyp
       AND bukrs EQ @iv_bukrs
       AND belnr EQ @iv_belnr
       AND gjahr EQ @iv_gjahr.
    CHECK sy-subrc NE 0.

    CASE iv_awtyp.
      WHEN 'LIKP'.
        rs_document = outgoing_delivery_save_likp( iv_awtyp = iv_awtyp
                                                   iv_bukrs = iv_bukrs
                                                   iv_belnr = iv_belnr
                                                   iv_gjahr = iv_gjahr ).
      WHEN 'MKPF'.
        rs_document = outgoing_delivery_save_mkpf( iv_awtyp = iv_awtyp
                                                   iv_bukrs = iv_bukrs
                                                   iv_belnr = iv_belnr
                                                   iv_gjahr = iv_gjahr ).
      WHEN 'BKPF' OR 'BKPFF'.
        rs_document = outgoing_delivery_save_bkpf( iv_awtyp = iv_awtyp
                                                   iv_bukrs = iv_bukrs
                                                   iv_belnr = iv_belnr
                                                   iv_gjahr = iv_gjahr ).
    ENDCASE.

    CHECK rs_document IS NOT INITIAL.
    INSERT zetr_t_ogdlv FROM @rs_document.
    DATA(ls_transport) = CORRESPONDING zetr_t_odth( rs_document ).
    INSERT zetr_t_odth FROM @ls_transport.
    zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-created
                                               iv_document_id = rs_document-docui ).
    COMMIT WORK AND WAIT.
  ENDMETHOD.