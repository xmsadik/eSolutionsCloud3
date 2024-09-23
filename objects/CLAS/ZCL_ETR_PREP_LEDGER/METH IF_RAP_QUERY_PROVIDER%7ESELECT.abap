  METHOD if_rap_query_provider~select.

*    DATA(lv_entity_id) = io_request->get_entity_id( ).
*
*    CASE lv_entity_id.
*      WHEN 'ZETR_DDL_I_PREP_LEDGER'.
*        select_prep_ledger( io_request  = io_request
*                            io_response = io_response ).
*      WHEN 'ZETR_DDL_I_PREP_LEDGER_DETAIL'.
*        select_prep_ledger_detail( io_request  = io_request
*                                   io_response = io_response ).
*      WHEN 'ZETR_DDL_I_SETPART_LEDGER'.
*        select_setpart_ledger( io_request  = io_request
*                               io_response = io_response ).
*    ENDCASE.

  ENDMETHOD.