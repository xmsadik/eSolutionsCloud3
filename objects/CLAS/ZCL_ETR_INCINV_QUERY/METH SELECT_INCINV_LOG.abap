  METHOD select_incinv_log.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_logs.
    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lv_top) = lo_paging->get_page_size( ).
    DATA(lv_skip) = lo_paging->get_offset( ).
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.
    READ TABLE lt_filter INTO DATA(ls_filter_docui) WITH KEY name = 'DOCUMENTUUID'.
    CHECK sy-subrc = 0.
    READ TABLE lt_filter INTO DATA(ls_filter_logui) WITH KEY name = 'LOGUUID'.
    SELECT *
      FROM zetr_ddl_i_document_logs
      WHERE DocumentUUID IN @ls_filter_docui-range
        AND LogUUID IN @ls_filter_logui-range
      ORDER BY loguuid
      INTO CORRESPONDING FIELDS OF TABLE @lt_output
      UP TO @lv_top ROWS
      OFFSET @lv_skip .
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.