  METHOD conversion_invoice_type_output.
    CASE iv_input.
      WHEN 'IHRACKAYIT'.
        CONCATENATE iv_input 'LI' INTO rv_output.
      WHEN 'TEVIADE'.
        rv_output = 'TEVKIFATIADE'.
      WHEN 'ILAC_TIBBI'.
        rv_output = 'ILAC_TIBBICIHAZ'.
      WHEN 'KONAKLAMA'.
        rv_output = 'KONAKLAMAVERGISI'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.