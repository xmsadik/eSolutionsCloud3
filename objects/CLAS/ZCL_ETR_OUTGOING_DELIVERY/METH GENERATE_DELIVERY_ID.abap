  METHOD generate_delivery_id.
    DATA: ls_serial        TYPE zetr_t_eiser,
          lv_number_object TYPE cl_numberrange_runtime=>nr_object,
          lv_gjahr         TYPE gjahr,
          lv_number        TYPE cl_numberrange_runtime=>nr_number,
          lv_delivery_no   TYPE c LENGTH 16,
          lv_days          TYPE i,
          lv_days_num      TYPE n LENGTH 1.
    DATA(lv_bldat) = cl_abap_context_info=>get_system_date( ).
    lv_gjahr = lv_bldat(4).
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

    CASE ms_company_parameters-genid.
      WHEN 'X'.
        WHILE ms_document-dlvno IS INITIAL.
          CONCATENATE ls_serial-serpr lv_gjahr '%' INTO lv_delivery_no.
          SELECT MAX( bldat )
            FROM zetr_t_ogdlv
            WHERE bukrs = @ms_document-bukrs
              AND dlvno LIKE @lv_delivery_no
            INTO @DATA(lv_max_date).
          IF sy-subrc IS NOT INITIAL OR lv_max_date IS INITIAL OR lv_max_date LE lv_bldat.
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
        IF lv_days >= 8.
          lv_days_num = 8.
        ELSE.
          lv_days_num = lv_days.
        ENDIF.
        CONCATENATE ls_serial-serpr lv_days_num lv_gjahr INTO lv_delivery_no.
        CONCATENATE ls_serial-numrn lv_days_num INTO ls_serial-numrn.
*        DO lv_days_num TIMES.
*          SELECT SINGLE *
*            FROM zetr_t_eiser
*            WHERE bukrs = @ms_document-bukrs
*              AND serpr = @ls_serial-nxtsp
*            INTO @ls_serial.
*          IF sy-subrc IS NOT INITIAL.
*            RAISE EXCEPTION TYPE zcx_etr_regulative_exception
*              MESSAGE e031(zetr_common) WITH ms_document-serpr.
*          ENDIF.
*        ENDDO.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = ls_serial-numrn
            object            = lv_number_object
            quantity          = 1
            subobject         = CONV #( ms_document-bukrs )
            toyear            = lv_gjahr
          IMPORTING
            number            = lv_number ).
        ms_document-dlvno = lv_delivery_no && lv_number+7(*).
*        ms_document-dlvno = lv_number+4(*).
*        ms_document-dlvno(3) = ls_serial-serpr.
*        ms_document-dlvno+3(4) = lv_gjahr.
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