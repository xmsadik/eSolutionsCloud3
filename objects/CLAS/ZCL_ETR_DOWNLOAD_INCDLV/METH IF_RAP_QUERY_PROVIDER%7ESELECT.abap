  METHOD if_rap_query_provider~select.
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA: lv_begda    TYPE datum,
              lv_endda    TYPE datum,
              lt_list_all TYPE zcl_etr_delivery_operations=>mty_incoming_list.
        DATA(lt_paging) = io_request->get_paging( ).
        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'BUKRS'.
              SELECT bukrs, title
                FROM zetr_t_cmpin
                WHERE bukrs IN @ls_filter-range
                INTO TABLE @DATA(lt_companies).
            WHEN 'RECDT'.
              READ TABLE ls_filter-range INTO DATA(ls_range) INDEX 1.
              IF sy-subrc = 0.
                lv_begda = ls_range-low.
                lv_endda = ls_range-high.
              ENDIF.
          ENDCASE.
        ENDLOOP.
        IF NOT line_exists( lt_filter[ name = 'BUKRS' ] ).
          SELECT bukrs, title
            FROM zetr_t_cmpin
            INTO TABLE @lt_companies.
        ENDIF.
        CHECK lt_companies IS NOT INITIAL.
        SORT lt_companies BY bukrs.

        LOOP AT lt_companies INTO DATA(ls_company).
          TRY.
              DATA(lo_delivery_operations) = zcl_etr_delivery_operations=>factory( ls_company-bukrs ).
              lo_delivery_operations->get_incoming_deliveries(
                EXPORTING
                  iv_date_from = lv_begda
                  iv_date_to   = lv_endda
                IMPORTING
                  et_list      = DATA(lt_list)
                  et_items     = DATA(lt_items) ).
              APPEND LINES OF lt_list TO lt_list_all.
            CATCH zcx_etr_regulative_exception INTO DATA(lx_regulative_exception).
          ENDTRY.
          CLEAR: lt_list, lt_items, lo_delivery_operations.
        ENDLOOP.
        DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_download_incdlv.
        lt_output = CORRESPONDING #( lt_list_all ).
        IF lt_output IS NOT INITIAL.
          SELECT taxid, title, regdt
            FROM zetr_t_dlv_ruser
            FOR ALL ENTRIES IN @lt_output
            WHERE taxid = @lt_output-taxid
              AND regdt <= @lt_output-bldat
            INTO TABLE @DATA(lt_users).
          SORT lt_users BY taxid regdt DESCENDING.
        ENDIF.
        LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
          <ls_output>-title = VALUE #( lt_users[ taxid = <ls_output>-taxid ]-title OPTIONAL ).
        ENDLOOP.
        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_output ) ).
        ENDIF.
        io_response->set_data( it_data = lt_output ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
  ENDMETHOD.