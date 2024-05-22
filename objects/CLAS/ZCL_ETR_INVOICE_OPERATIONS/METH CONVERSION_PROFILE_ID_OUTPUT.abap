  METHOD conversion_profile_id_output.
    CASE iv_input.
      WHEN 'TEMEL' OR 'TICARI' OR 'EARSIV' OR 'STDKOD'.
        CONCATENATE iv_input 'FATURA' INTO rv_output.
      WHEN 'YOLCU'.
        rv_output = 'YOLCUBERABERFATURA'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.