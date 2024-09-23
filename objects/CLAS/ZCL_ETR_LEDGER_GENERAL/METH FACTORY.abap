  METHOD factory.
    SELECT SINGLE *
      FROM zetr_t_srkdb
      WHERE bukrs = @iv_company_code
      INTO @DATA(ls_company_data).
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ENDIF.

    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @ls_company_data-bukrs
        AND prncl = 'ZCL_ETR_LEDGER_GENERAL'
      INTO @DATA(lv_reference_class).

    IF lv_reference_class IS INITIAL.
      lv_reference_class = 'ZCL_ETR_LEDGER_GENERAL'.
    ENDIF.

    TRY .
        CREATE OBJECT ro_object TYPE (lv_reference_class).
*        ro_object->set_initial_data( is_document = ls_document
*                                     iv_preview = iv_preview ).
      CATCH cx_sy_create_object_error INTO DATA(lx_create_object_error).
        DATA(lv_message) = CONV bapi_msg( lx_create_object_error->get_text( ) ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '000'
            WITH lv_message(50) lv_message+50(50) lv_message+100(50) lv_message+150(*).
    ENDTRY.
  ENDMETHOD.