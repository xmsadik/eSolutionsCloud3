  METHOD generate_delivery_id.
    DATA: ls_serial        TYPE zetr_t_eiser,
          lv_number_object TYPE cl_numberrange_runtime=>nr_object,
          lv_gjahr         TYPE gjahr,
          lv_number        TYPE cl_numberrange_runtime=>nr_number.
    DATA(lv_bldat) = cl_abap_context_info=>get_system_date( ).
    lv_gjahr = lv_bldat(4).
*    lv_gjahr = ms_document-bldat(4).
    lv_number_object = 'ZETR_EDL'.
    SELECT SINGLE *
      FROM zetr_t_edser
      WHERE bukrs = @ms_document-bukrs
        AND serpr = @ms_document-serpr
      INTO CORRESPONDING FIELDS OF @ls_serial.
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e030(zetr_common).
    ENDIF.

    DATA lv_invoice_no TYPE c LENGTH 16.
    DATA lv_days TYPE i.
    DATA lv_days_num TYPE n LENGTH 1.

    CASE ms_company_parameters-genid.
      WHEN 'X'.
        WHILE ms_document-dlvno IS INITIAL.
          CONCATENATE ls_serial-serpr lv_gjahr '%' INTO lv_invoice_no.
          SELECT MAX( bldat )
            FROM zetr_t_ogdlv
            WHERE bukrs = @ms_document-bukrs
              AND dlvno LIKE @lv_invoice_no
            INTO @DATA(lv_max_date).
*          IF sy-subrc IS NOT INITIAL OR lv_max_date IS INITIAL OR lv_max_date LE ms_document-bldat.
          IF sy-subrc IS NOT INITIAL OR lv_max_date IS INITIAL OR lv_max_date LE lv_bldat.
            TRY.
                cl_numberrange_runtime=>number_get(
                  EXPORTING
                    nr_range_nr       = ls_serial-numrn
                    object            = lv_number_object
                    quantity          = 1
                    subobject         = CONV #( ms_document-bukrs )
                    toyear            = lv_gjahr
                  IMPORTING
                    number            = lv_number ).
                ms_document-dlvno = lv_number+4(*).
                ms_document-dlvno(3) = ls_serial-serpr.
                ms_document-dlvno+3(4) = lv_gjahr.
              CATCH cx_root INTO DATA(lx_root).
                DATA(lv_error) = lx_root->get_text( ).
                RAISE EXCEPTION TYPE zcx_etr_regulative_exception
                  MESSAGE e000(zetr_common) WITH lv_error(50) lv_error+50(50) lv_error+100(50) lv_error+150(*).
            ENDTRY.
          ELSEIF ls_serial-nxtsp IS INITIAL.
            RAISE EXCEPTION TYPE zcx_etr_regulative_exception
              MESSAGE e031(zetr_common) WITH ms_document-serpr.
          ELSE.
            lv_number_object = 'ZETR_EDL'.
            SELECT SINGLE *
              FROM zetr_t_eiser
              WHERE bukrs = @ms_document-bukrs
                AND serpr = @ls_serial-nxtsp
              INTO @ls_serial.
            IF sy-subrc IS NOT INITIAL.
              RAISE EXCEPTION TYPE zcx_etr_regulative_exception
                MESSAGE e031(zetr_common) WITH ms_document-serpr.
            ENDIF.
          ENDIF.
        ENDWHILE.
      WHEN 'D'.
        lv_days = cl_abap_context_info=>get_system_date( ) - lv_bldat.
*        lv_days = cl_abap_context_info=>get_system_date( ) - ms_document-bldat.
        IF lv_days >= 8.
          lv_days_num = 8.
        ELSE.
          lv_days_num = lv_days.
        ENDIF.
        CONCATENATE ls_serial-serpr lv_days_num lv_gjahr INTO lv_invoice_no.
        CONCATENATE ls_serial-numrn lv_days_num INTO ls_serial-numrn.
        TRY.
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr       = ls_serial-numrn
                object            = lv_number_object
                quantity          = 1
                subobject         = CONV #( ms_document-bukrs )
                toyear            = lv_gjahr
              IMPORTING
                number            = lv_number ).
            ms_document-dlvno = lv_number+4(*).
            ms_document-dlvno(7) = lv_invoice_no.
          CATCH cx_root INTO lx_root.
            lv_error = lx_root->get_text( ).
            RAISE EXCEPTION TYPE zcx_etr_regulative_exception
              MESSAGE e000(zetr_common) WITH lv_error(50) lv_error+50(50) lv_error+100(50) lv_error+150(*).
        ENDTRY.
    ENDCASE.

    IF ms_document-dlvno IS NOT INITIAL.
      rv_invoice_number = ms_document-dlvno.
      CHECK iv_save_db = abap_true.
      UPDATE zetr_t_ogdlv
        SET dlvno = @ms_document-dlvno
        WHERE docui = @ms_document-docui.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.