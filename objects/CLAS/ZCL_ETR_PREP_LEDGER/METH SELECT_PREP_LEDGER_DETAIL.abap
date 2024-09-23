  METHOD select_prep_ledger_detail.

*    TRY.
*
*        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
*
*        DATA : ls_output TYPE zetr_ddl_i_prep_ledger_detail,
*               lt_output TYPE TABLE OF zetr_ddl_i_prep_ledger_detail.
*
*        DATA(lt_paging) = io_request->get_paging( ).
*
*        DATA : ls_balance TYPE zetr_s_trial_balance.
*
*
*
*        LOOP AT lt_filter INTO DATA(ls_filter).
*          CASE ls_filter-name.
*            WHEN 'BUKRS'.
*              ls_output-bukrs = ls_filter-range[ 1 ]-low .
*            WHEN 'GJAHR'.
*              ls_output-gjahr = ls_filter-range[ 1 ]-low .
*            WHEN 'MONAT'.
*              ls_output-monat = ls_filter-range[ 1 ]-low .
*          ENDCASE.
*        ENDLOOP.
*
*        zcl_etr_trial_balance_service=>trigger_trial_balance_service(
*          EXPORTING
*            iv_company_code = ls_output-bukrs
*            iv_ledger       = '0L'
*            iv_gjahr        = ls_output-gjahr
*            iv_monat        = ls_output-monat
*          RECEIVING
*            rs_balance      = ls_balance
*         ).
*
*
*        ls_output-stdebit = ls_balance-debits_per.
*        ls_output-stcrdit = ls_balance-credit_per.
*        ls_output-waers   = 'TRY'.
*
*
*        APPEND ls_output TO lt_output.
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