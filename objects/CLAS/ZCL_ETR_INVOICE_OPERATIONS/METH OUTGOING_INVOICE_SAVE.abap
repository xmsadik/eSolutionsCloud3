  METHOD outgoing_invoice_save.
    SELECT COUNT(*)
      FROM zetr_t_oginv
      WHERE awtyp EQ @iv_awtyp
        AND bukrs EQ @iv_bukrs
        AND belnr EQ @iv_belnr
        AND gjahr EQ @iv_gjahr.
    CHECK sy-subrc NE 0.

    CASE iv_awtyp.
      WHEN 'VBRK'.
        rs_document = outgoing_invoice_save_vbrk( iv_awtyp = iv_awtyp
                                                  iv_bukrs = iv_bukrs
                                                  iv_belnr = iv_belnr
                                                  iv_gjahr = iv_gjahr ).
      WHEN 'RMRP'.
        rs_document = outgoing_invoice_save_rmrp( iv_awtyp = iv_awtyp
                                                  iv_bukrs = iv_bukrs
                                                  iv_belnr = iv_belnr
                                                  iv_gjahr = iv_gjahr ).
      WHEN 'BKPF' OR 'BKPFF' OR 'REACI'.
        rs_document = outgoing_invoice_save_bkpf( iv_awtyp = iv_awtyp
                                                  iv_bukrs = iv_bukrs
                                                  iv_belnr = iv_belnr
                                                  iv_gjahr = iv_gjahr ).
    ENDCASE.

    CHECK rs_document IS NOT INITIAL.
    INSERT zetr_t_oginv FROM @rs_document.
    zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-created
                                               iv_document_id = rs_document-docui ).
    COMMIT WORK AND WAIT.
  ENDMETHOD.