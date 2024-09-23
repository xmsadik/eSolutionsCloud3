  METHOD select_setpart_ledger.

*    TRY.
*
*        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
*
*        DATA : ls_output TYPE zetr_ddl_i_setpart_ledger,
*               lt_output TYPE TABLE OF zetr_ddl_i_setpart_ledger.
*
*        DATA : lv_bukrs TYPE bukrs,
*               lv_gjahr TYPE gjahr,
*               lv_monat TYPE monat.
*
*
*        DATA(lt_paging) = io_request->get_paging( ).
*
*
*        LOOP AT lt_filter INTO DATA(ls_filter).
*          CASE ls_filter-name.
*            WHEN 'BUKRS'.
*              lv_bukrs = ls_filter-range[ 1 ]-low .
*            WHEN 'GJAHR'.
*              lv_gjahr = ls_filter-range[ 1 ]-low .
*            WHEN 'MONAT'.
*              lv_monat = ls_filter-range[ 1 ]-low .
*          ENDCASE.
*        ENDLOOP.
*
*****************
*        "Lt_output defky den akan bilgilerle doldur @YiğitcanÖ.
*****************
*
*
*        IF io_request->is_total_numb_of_rec_requested(  ).
*          io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_output ) ).
*        ENDIF.
*        io_response->set_data( it_data = lt_output ).
*
*
*      CATCH cx_rap_query_filter_no_range.
*    ENDTRY.


  ENDMETHOD.