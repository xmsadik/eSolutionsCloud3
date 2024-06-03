  METHOD set_initial_data.
    ms_document = is_document.
    mv_preview = iv_preview.
    mv_profile_id = is_document-prfid.
    mo_invoice_operations = zcl_etr_invoice_operations=>factory( ms_document-bukrs ).

    SELECT SINGLE value
      FROM zetr_t_cmppi
      WHERE bukrs = @ms_document-bukrs
        AND prtid = 'VKN'
      INTO @mv_company_taxid.
    CASE ms_document-prfid.
      WHEN 'EARSIV'.
        SELECT SINGLE genid, barcode
          FROM zetr_t_eapar
          WHERE bukrs = @ms_document-bukrs
          INTO @DATA(ls_earp).
        mv_generate_invoice_id = ls_earp-genid.
        mv_barcode = ls_earp-barcode.
        IF mv_company_taxid IS INITIAL.
          SELECT SINGLE value
            FROM zetr_t_eacus
            WHERE bukrs = @ms_document-bukrs
              AND cuspa = 'TESTVKN'
            INTO @mv_company_taxid.
        ENDIF.

        SELECT SINGLE value
          FROM zetr_t_eacus
          WHERE bukrs = @ms_document-bukrs
            AND cuspa = 'ADDSIGN'
          INTO @mv_add_signature.
      WHEN OTHERS.
        SELECT SINGLE genid, barcode
          FROM zetr_t_eipar
          WHERE bukrs = @ms_document-bukrs
          INTO @DATA(ls_einp).
        mv_generate_invoice_id = ls_einp-genid.
        mv_barcode = ls_einp-barcode.
        IF mv_company_taxid IS INITIAL.
          SELECT SINGLE value
            FROM zetr_t_eicus
            WHERE bukrs = @ms_document-bukrs
              AND cuspa = 'TESTVKN'
            INTO @mv_company_taxid.
        ENDIF.

        SELECT SINGLE value
          FROM zetr_t_eicus
          WHERE bukrs = @ms_document-bukrs
            AND cuspa = 'ADDSIGN'
          INTO @mv_add_signature.
    ENDCASE.
  ENDMETHOD.