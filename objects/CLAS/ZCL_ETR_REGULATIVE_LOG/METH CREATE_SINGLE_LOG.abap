  METHOD create_single_log.
    DATA: lt_log_db TYPE TABLE OF zetr_t_logs,
          ls_log_db TYPE zetr_t_logs.
    TRY.
        ls_log_db-logui = cl_system_uuid=>create_uuid_c22_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.
    ls_log_db-docui = iv_document_id.
    ls_log_db-uname = sy-uname.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE ls_log_db-datum TIME ls_log_db-uzeit.
    ls_log_db-logcd = iv_log_code.
    ls_log_db-lnote = iv_log_text.
    INSERT zetr_t_logs FROM @ls_log_db.
  ENDMETHOD.