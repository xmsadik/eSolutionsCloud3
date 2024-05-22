  METHOD get_service_parameters.
    ms_company_parameters = is_company_parameters.

    SELECT *
      FROM zetr_t_edcus
      WHERE bukrs = @ms_company_parameters-bukrs
      INTO TABLE @mt_custom_parameters.

    SELECT *
      FROM zetr_t_cmpcp
      WHERE bukrs = @ms_company_parameters-bukrs
      APPENDING TABLE @mt_custom_parameters.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_testvkn_parameter.
    IF sy-subrc = 0.
      mv_company_taxid = ls_custom_parameter-value.
    ELSE.
      SELECT SINGLE value
        FROM zetr_t_cmppi
        WHERE bukrs = @ms_company_parameters-bukrs
          AND prtid = 'VKN'
        INTO @mv_company_taxid.
    ENDIF.
  ENDMETHOD.