  METHOD invoice_abap_to_ubl.
    TRY.
        CALL TRANSFORMATION zetr_ubl21_invoice
          SOURCE root = ms_invoice_ubl
          RESULT XML mv_invoice_ubl.
        mv_invoice_hash = zcl_etr_regulative_common=>calculate_hash_for_raw( mv_invoice_ubl ).
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_error) = lx_root->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e000(zetr_common) WITH lv_error(50) lv_error+50(50) lv_error+100(50) lv_error+150(*).
    ENDTRY.
  ENDMETHOD.