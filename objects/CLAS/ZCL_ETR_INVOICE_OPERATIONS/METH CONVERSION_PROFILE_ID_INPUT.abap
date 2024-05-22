  METHOD conversion_profile_id_input.
    CASE iv_input.
      WHEN 'TEMELFATURA' OR 'TICARIFATURA' OR 'EARSIVFATURA' OR 'STDKODFATURA'.
        rv_output = iv_input.
        REPLACE 'FATURA' IN rv_output WITH ``.
      WHEN 'YOLCUBERABERFATURA'.
        rv_output = 'YOLCU'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.