  METHOD incoming_einvoice_addnote.
    UPDATE zetr_t_icinv
      SET lnote = @iv_note,
          luser = @iv_user
      WHERE docui = @iv_document_uid.

    zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-note_added
                                               iv_log_text    = iv_note
                                               iv_document_id = iv_document_uid ).
  ENDMETHOD.