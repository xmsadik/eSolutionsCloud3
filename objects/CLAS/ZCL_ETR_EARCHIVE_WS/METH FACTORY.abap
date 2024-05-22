  METHOD factory.
    SELECT SINGLE *
      FROM zetr_t_eapar
      WHERE bukrs = @iv_company
      INTO @DATA(ls_company_parameters).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '001'.
    ENDIF.

    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @iv_company
        AND prncl = 'ZCL_ETR_EARCHIVE_WS'
      INTO @DATA(lv_reference_class).

    IF lv_reference_class IS INITIAL.
      CONCATENATE 'ZCL_ETR_EARCHIVE_WS_' ls_company_parameters-intid INTO lv_reference_class.
    ENDIF.

    TRY .
        CREATE OBJECT ro_instance TYPE (lv_reference_class).
        ro_instance->get_service_parameters( ls_company_parameters ).
      CATCH cx_sy_create_object_error INTO DATA(lx_create_object_error).
        DATA(lv_error_text) = lx_create_object_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '000'
            WITH lv_error_text(50) lv_error_text+50(50) lv_error_text+100(50) lv_error_text+150(50).
    ENDTRY.
  ENDMETHOD.