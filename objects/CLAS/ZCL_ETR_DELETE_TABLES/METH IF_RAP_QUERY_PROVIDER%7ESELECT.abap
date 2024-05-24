  METHOD if_rap_query_provider~select.
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA: lt_bukrs_range TYPE RANGE OF bukrs,
              lt_belnr_range TYPE RANGE OF belnr_d,
              lt_gjahr_range TYPE RANGE OF gjahr,
              lt_taxid_range TYPE RANGE OF zetr_e_taxid,
              lt_table_range TYPE RANGE OF zetr_e_table,
              lt_docui_range TYPE RANGE OF sysuuid_c22,
              lt_docui_rtemp TYPE RANGE OF sysuuid_c22,
              lt_output      TYPE TABLE OF zetr_ddl_i_delete_tables.
        DATA(lt_paging) = io_request->get_paging( ).
        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'BUKRS'.
              lt_bukrs_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'BELNR'.
              lt_belnr_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'GJAHR'.
              lt_gjahr_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'TABNM'.
              lt_table_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'TAXID'.
              lt_taxid_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'DOCUI'.
              lt_docui_range = CORRESPONDING #( ls_filter-range ).
          ENDCASE.
        ENDLOOP.

        IF 'OGINV' IN lt_table_range.
          SELECT docui, bukrs, belnr, gjahr, 'OGINV' AS tabnm
            FROM zetr_t_oginv
            WHERE docui IN @lt_docui_range
              AND bukrs IN @lt_bukrs_range
              AND belnr IN @lt_belnr_range
              AND gjahr IN @lt_gjahr_range
              AND taxid IN @lt_taxid_range
            INTO TABLE @lt_output.
          IF sy-subrc = 0.
            lt_docui_rtemp = VALUE #( FOR ls_output IN lt_output ( sign = 'I' option = 'EQ' low = ls_output-docui ) ).
            DELETE FROM zetr_t_oginv
              WHERE docui IN @lt_docui_rtemp.
            DELETE FROM zetr_t_arcd
              WHERE docui IN @lt_docui_rtemp.
          ENDIF.
        ENDIF.

        IF 'OGDLV' IN lt_table_range.
          SELECT docui, bukrs, belnr, gjahr, 'OGDLV' AS tabnm
            FROM zetr_t_ogdlv
            WHERE docui IN @lt_docui_range
              AND bukrs IN @lt_bukrs_range
              AND belnr IN @lt_belnr_range
              AND gjahr IN @lt_gjahr_range
              AND taxid IN @lt_taxid_range
            APPENDING TABLE @lt_output.
          IF sy-subrc = 0.
            lt_docui_rtemp = VALUE #( FOR ls_output IN lt_output ( sign = 'I' option = 'EQ' low = ls_output-docui ) ).
            DELETE FROM zetr_t_ogdlv
              WHERE docui IN @lt_docui_rtemp.
            DELETE FROM zetr_t_arcd
              WHERE docui IN @lt_docui_rtemp.
          ENDIF.
        ENDIF.

        IF 'ICINV' IN lt_table_range.
          SELECT docui, bukrs, taxid, 'ICINV' AS tabnm
            FROM zetr_t_icinv
            WHERE docui IN @lt_docui_range
              AND bukrs IN @lt_bukrs_range
              AND taxid IN @lt_taxid_range
            APPENDING CORRESPONDING FIELDS OF TABLE @lt_output.
          IF sy-subrc = 0.
            lt_docui_rtemp = VALUE #( FOR ls_output IN lt_output ( sign = 'I' option = 'EQ' low = ls_output-docui ) ).
            DELETE FROM zetr_t_icinv
              WHERE docui IN @lt_docui_rtemp.
            DELETE FROM zetr_t_arcd
              WHERE docui IN @lt_docui_rtemp.
          ENDIF.
        ENDIF.

        IF 'ICDLV' IN lt_table_range.
          SELECT docui, bukrs, taxid, 'ICDLV' AS tabnm
            FROM zetr_t_icdlv
            WHERE docui IN @lt_docui_range
              AND bukrs IN @lt_bukrs_range
              AND taxid IN @lt_taxid_range
            APPENDING CORRESPONDING FIELDS OF TABLE @lt_output.
          IF sy-subrc = 0.
            lt_docui_rtemp = VALUE #( FOR ls_output IN lt_output ( sign = 'I' option = 'EQ' low = ls_output-docui ) ).
            DELETE FROM zetr_t_icdlv
              WHERE docui IN @lt_docui_rtemp.
            DELETE FROM zetr_t_arcd
              WHERE docui IN @lt_docui_rtemp.
          ENDIF.
        ENDIF.

        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_output ) ).
        ENDIF.
        io_response->set_data( it_data = lt_output ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
  ENDMETHOD.