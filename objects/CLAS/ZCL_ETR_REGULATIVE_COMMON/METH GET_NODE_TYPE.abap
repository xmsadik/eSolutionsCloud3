  METHOD get_node_type.
    CASE node_type_int.
      WHEN if_sxml_node=>co_nt_initial.
        node_type_string = `CO_NT_INITIAL`.
*      WHEN if_sxml_node=>co_nt_comment.
*        node_type_string = `CO_NT_COMMENT`.
      WHEN if_sxml_node=>co_nt_element_open.
        node_type_string = `CO_NT_ELEMENT_OPEN`.
      WHEN if_sxml_node=>co_nt_element_close.
        node_type_string = `CO_NT_ELEMENT_CLOSE`.
      WHEN if_sxml_node=>co_nt_value.
        node_type_string = `CO_NT_VALUE`.
      WHEN if_sxml_node=>co_nt_attribute.
        node_type_string = `CO_NT_ATTRIBUTE`.
*      WHEN if_sxml_node=>co_nt_pi.
*        node_type_string = `CO_NT_FINAL`.
      WHEN OTHERS.
        node_type_string = `Error`.
    ENDCASE.
  ENDMETHOD.