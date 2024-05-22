  METHOD get_value_type.
    CASE value_type_int.
      WHEN 0.
        value_type_string = `Initial`.
      WHEN if_sxml_value=>co_vt_none .
        value_type_string = `CO_VT_NONE`.
      WHEN if_sxml_value=>co_vt_text.
        value_type_string = `CO_VT_TEXT`.
      WHEN if_sxml_value=>co_vt_raw.
        value_type_string = `CO_VT_RAW`.
      WHEN if_sxml_value=>co_vt_any.
        value_type_string = `CO_VT_ANY`.
      WHEN OTHERS.
        value_type_string = `Error`.
    ENDCASE.
  ENDMETHOD.