  METHOD build_invoice_data_vbrk_export.
*    IF ms_billing_data-vbrk-kunwe IS NOT INITIAL.
*      MOVE-CORRESPONDING ms_billing_data-vbrk TO rs_data.
*    ELSE.
    MOVE-CORRESPONDING is_vbrp TO rs_data.
*    ENDIF.

    rs_data-inco1 = ms_billing_data-vbrk-inco1.

    IF ms_document-trnsp IS NOT INITIAL.
      rs_data-trnty = ms_document-trnsp.
    ELSEIF is_vbrp-vgvsa IS NOT INITIAL.
      DATA(lv_vsart) = is_vbrp-vgvsa.
    ELSE.
      lv_vsart = is_vbrp-auvsa.
    ENDIF.

    IF lv_vsart IS NOT INITIAL AND rs_data-trnty IS INITIAL.
      SELECT SINGLE trnsp
        FROM zetr_t_trnmc
        WHERE vsart = @lv_vsart
        INTO @rs_data-trnty.
    ENDIF.

    rs_data-hscod = is_vbrp-hscod.

    READ TABLE ms_billing_data-conditions
      INTO DATA(ls_conditions)
      WITH TABLE KEY by_cndty
      COMPONENTS cndty = 'F'.
    IF sy-subrc IS INITIAL.
      READ TABLE ms_billing_data-konv
        INTO DATA(ls_konv)
        WITH TABLE KEY by_kschl
        COMPONENTS kposn = is_vbrp-posnr
                   kschl = ls_conditions-kschl
                   kinak = space.
      IF sy-subrc IS INITIAL.
        rs_data-kwrfr = abs( ls_konv-kwert ).
      ENDIF.
    ENDIF.

    READ TABLE ms_billing_data-conditions
      INTO ls_conditions
      WITH TABLE KEY by_cndty
      COMPONENTS cndty = 'I'.
    IF sy-subrc IS INITIAL.
      READ TABLE ms_billing_data-konv
        INTO ls_konv
        WITH TABLE KEY by_kschl
        COMPONENTS kposn = is_vbrp-posnr
                   kschl = ls_conditions-kschl
                   kinak = space.
      IF sy-subrc IS INITIAL.
        rs_data-kwrin = abs( ls_konv-kwert ).
      ENDIF.
    ENDIF.
  ENDMETHOD.