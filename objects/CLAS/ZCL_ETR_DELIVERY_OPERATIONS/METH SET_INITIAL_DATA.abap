  METHOD set_initial_data.
    mv_company_code = iv_company.

    SELECT SINGLE value
      FROM zetr_t_cmppi
      WHERE bukrs = @mv_company_code
        AND prtid = 'VKN'
      INTO @mv_company_taxid.
    IF mv_company_taxid IS INITIAL.
      SELECT SINGLE value
        FROM zetr_t_edcus
        WHERE bukrs = @mv_company_code
          AND cuspa = 'TEST_VKN'
        INTO @mv_company_taxid.
    ENDIF.
  ENDMETHOD.