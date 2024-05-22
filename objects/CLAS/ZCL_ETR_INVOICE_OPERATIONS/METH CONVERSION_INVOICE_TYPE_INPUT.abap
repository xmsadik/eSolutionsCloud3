  METHOD conversion_invoice_type_input.
    CASE iv_input.
      WHEN 'IHRACKAYITLI'.
        rv_output = 'IHRACKAYIT'.
      WHEN 'TEVKIFATIADE'.
        rv_output = 'TEVIADE'.
      WHEN 'ILAC_TIBBICIHAZ'.
        rv_output = 'ILAC_TIBBI'.
      WHEN 'KONAKLAMAVERGISI'.
        rv_output = 'KONAKLAMA'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.