  METHOD if_rap_query_provider~select.
    DATA(lv_entity_id) = io_request->get_entity_id( ).
    DATA(lv_data_requested) = io_request->is_data_requested( ).
    CASE lv_entity_id.
      WHEN 'ZETR_DDL_I_INCINV_LIST'.
        select_incinv_list( io_request  = io_request
                            io_response = io_response ).
      WHEN 'ZETR_DDL_I_INCINV_CONTENT'.
        select_incinv_content( io_request  = io_request
                               io_response = io_response ).
      WHEN 'ZETR_DDL_I_INCINV_LOGS'.
        select_incinv_log( io_request  = io_request
                           io_response = io_response ).
    ENDCASE.
  ENDMETHOD.