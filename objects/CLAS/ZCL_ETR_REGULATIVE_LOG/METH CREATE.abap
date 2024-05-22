  METHOD create.
    DATA: lt_log_db TYPE TABLE OF zetr_t_logs,
          ls_log_db TYPE zetr_t_logs,
          lt_logs   TYPE zetr_tt_log_data,
          ls_logs   TYPE zetr_s_log_data.
    lt_logs = it_logs.
    LOOP AT lt_logs INTO ls_logs.
      ls_log_db = CORRESPONDING #( ls_logs ).
      TRY.
          ls_log_db-logui = cl_system_uuid=>create_uuid_c22_static( ).
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      APPEND ls_log_db TO lt_log_db.
      CLEAR ls_log_db.
    ENDLOOP.
    CHECK lt_log_db IS NOT INITIAL.
    INSERT zetr_t_logs FROM TABLE @lt_log_db.
  ENDMETHOD.