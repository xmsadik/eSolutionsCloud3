  METHOD if_rap_query_provider~select.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_logs.
    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lv_where_expression) = io_request->get_search_expression( ).
*    SELECT *
*      FROM zetr_ddl_i_incinv_logs
*      WHERE (lv_where_expression)
*      INTO CORRESPONDING FIELDS OF TABLE @DATA(lt_output).
    APPEND INITIAL LINE TO lt_output.
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.