  METHOD select_prep_ledger.
*
*    TRY.
*        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
*        DATA: lt_bukrs_range TYPE RANGE OF bukrs,
*              lt_gjahr_range TYPE RANGE OF gjahr,
*              lt_monat_range TYPE RANGE OF monat,
*              lt_output      TYPE TABLE OF zetr_ddl_i_prep_ledger,
*              ls_output      TYPE zetr_ddl_i_prep_ledger.
*        DATA(lt_paging) = io_request->get_paging( ).
*
*        LOOP AT lt_filter INTO DATA(ls_filter).
*          CASE ls_filter-name.
*            WHEN 'BUKRS'.
*              lt_bukrs_range = CORRESPONDING #( ls_filter-range ).
*            WHEN 'GJAHR'.
*              lt_gjahr_range = CORRESPONDING #( ls_filter-range ).
*            WHEN 'MONAT'.
*              lt_monat_range = CORRESPONDING #( ls_filter-range ).
*          ENDCASE.
*        ENDLOOP.
*
*        DATA(lv_bukrs) =  VALUE #( lt_bukrs_range[ 1 ]-low OPTIONAL ).
*        DATA(lv_gjahr) =  VALUE #( lt_gjahr_range[ 1 ]-low OPTIONAL ).
*        DATA(lv_monat) =  VALUE #( lt_monat_range[ 1 ]-low OPTIONAL ).
*
*        IF lv_monat IS NOT INITIAL.
*
*          ls_output-bukrs = lv_bukrs.
*          ls_output-gjahr = lv_gjahr.
*          ls_output-monat = lv_monat.
*          APPEND ls_output TO lt_output.
*
*        ELSE.
*
*          ls_output-bukrs = lv_bukrs.
*          ls_output-gjahr = lv_gjahr.
*
*          DO 12 TIMES.
*
*            ls_output-monat = ls_output-monat  + 1.
*            APPEND ls_output TO lt_output.
*
*          ENDDO.
*
*        ENDIF.
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