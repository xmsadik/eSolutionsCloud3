  METHOD set_initial_data.
    ms_document = is_document.
    mv_preview = iv_preview.
    mo_delivery_operations = zcl_etr_delivery_operations=>factory( ms_document-bukrs ).

    SELECT *
      FROM zetr_t_ogdli
      WHERE docui = @is_document-docui
      INTO TABLE @mt_saved_delivery_items.
    SELECT SINGLE *
      FROM zetr_t_edpar
      WHERE bukrs = @ms_document-bukrs
      INTO @ms_company_parameters.
    SELECT SINGLE value
      FROM zetr_t_cmppi
      WHERE bukrs = @ms_document-bukrs
        AND prtid = 'VKN'
      INTO @mv_company_taxid.
    IF mv_company_taxid IS INITIAL.
      SELECT SINGLE value
        FROM zetr_t_edcus
        WHERE bukrs = @ms_document-bukrs
          AND cuspa = 'TESTVKN'
        INTO @mv_company_taxid.
    ENDIF.
    SELECT SINGLE value
      FROM zetr_t_edcus
      WHERE bukrs = @ms_document-bukrs
        AND cuspa = 'ADDSIGN'
      INTO @mv_add_signature.
  ENDMETHOD.