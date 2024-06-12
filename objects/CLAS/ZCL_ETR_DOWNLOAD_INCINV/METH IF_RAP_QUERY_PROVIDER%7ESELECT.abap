  METHOD if_rap_query_provider~select.
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA: lv_begda    TYPE datum,
              lv_endda    TYPE datum,
              lv_imrec    TYPE zetr_e_imrec,
              lv_invui    TYPE zetr_e_duich,
              lt_list_all TYPE zcl_etr_invoice_operations=>mty_incoming_list.
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
                IF lv_endda IS INITIAL.
                  lv_endda = lv_begda.
                ENDIF.
              ENDIF.
            WHEN 'INVUI'.
              READ TABLE ls_filter-range INTO ls_range INDEX 1.
              IF sy-subrc = 0 AND ls_range-low IS NOT INITIAL.
                lv_invui = ls_range-low.
              ENDIF.
            WHEN 'IMREC'.
              READ TABLE ls_filter-range INTO ls_range INDEX 1.
              IF sy-subrc = 0 AND ls_range-low = 'X'.
                lv_imrec = abap_true.
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
              DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( ls_company-bukrs ).
              DATA(lt_invoice_list) = lo_invoice_operations->get_incoming_invoices( iv_date_from = lv_begda
                                                                                    iv_date_to   = lv_endda
                                                                                    iv_import_received = lv_imrec
                                                                                    iv_invoice_uuid = lv_invui ).
              APPEND LINES OF lt_invoice_list TO lt_list_all.
            CATCH zcx_etr_regulative_exception INTO DATA(lx_regulative_exception).
          ENDTRY.
          CLEAR: lt_invoice_list, lo_invoice_operations.
        ENDLOOP.
        DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_download_incinv.
        lt_output = CORRESPONDING #( lt_list_all ).
        IF lt_output IS NOT INITIAL.
          SELECT taxid, title
            FROM zetr_t_inv_ruser
            FOR ALL ENTRIES IN @lt_output
            WHERE taxid = @lt_output-taxid
            INTO TABLE @DATA(lt_users).
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