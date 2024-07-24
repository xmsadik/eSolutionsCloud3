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
        outgoing_delivery_save_likp(
          EXPORTING
            iv_awtyp = iv_awtyp
            iv_bukrs = iv_bukrs
            iv_belnr = iv_belnr
            iv_gjahr = iv_gjahr
          IMPORTING
            es_document = rs_document
            et_items    = DATA(lt_items) ).
      WHEN 'MKPF'.
        outgoing_delivery_save_mkpf(
          EXPORTING
            iv_awtyp = iv_awtyp
            iv_bukrs = iv_bukrs
            iv_belnr = iv_belnr
            iv_gjahr = iv_gjahr
          IMPORTING
            es_document = rs_document
            et_items    = lt_items ).
      WHEN 'BKPF' OR 'BKPFF'.
        outgoing_delivery_save_bkpf(
          EXPORTING
            iv_awtyp = iv_awtyp
            iv_bukrs = iv_bukrs
            iv_belnr = iv_belnr
            iv_gjahr = iv_gjahr
          IMPORTING
            es_document = rs_document
            et_items    = lt_items ).
    ENDCASE.

    CHECK rs_document IS NOT INITIAL.
    INSERT zetr_t_ogdlv FROM @rs_document.
    DATA lt_contents TYPE TABLE OF zetr_t_arcd.
    lt_contents = VALUE #( ( docty = 'OUTDLVDOC'
                             docui = rs_document-docui
                             conty = 'PDF' )
                           ( docty = 'OUTDLVDOC'
                             docui = rs_document-docui
                             conty = 'HTML' )
                           ( docty = 'OUTDLVDOC'
                             docui = rs_document-docui
                             conty = 'UBL' ) ).
    INSERT zetr_t_arcd FROM TABLE @lt_contents.
    DATA(ls_transport) = CORRESPONDING zetr_t_odth( rs_document EXCEPT taxid ).
    INSERT zetr_t_odth FROM @ls_transport.
    INSERT zetr_t_ogdli FROM TABLE @lt_items.
    zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-created
                                               iv_document_id = rs_document-docui ).
    COMMIT WORK AND WAIT.
  ENDMETHOD.