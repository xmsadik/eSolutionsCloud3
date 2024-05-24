  METHOD parse_xml.
    IF iv_xml_xstring IS INITIAL.
      DATA(lv_xml_raw) = cl_abap_conv_codepage=>create_out( )->convert(
              replace( val = iv_xml_string sub = |\n| with = `` occ = 0  ) ).
    ELSE.
      lv_xml_raw = iv_xml_xstring.
    ENDIF.
    DATA(lo_reader) = cl_sxml_string_reader=>create( lv_xml_raw ).
    TRY.
        DO.
          lo_reader->next_node( ).
          IF lo_reader->node_type = if_sxml_node=>co_nt_final.
            EXIT.
          ENDIF.
          APPEND VALUE #(
            node_type  = get_node_type( lo_reader->node_type )
            prefix     = lo_reader->prefix
            name       = lo_reader->name
            nsuri      = lo_reader->nsuri
            value_type = get_value_type( lo_reader->value_type )
            value      = lo_reader->value ) TO rt_data.
          IF lo_reader->node_type = if_sxml_node=>co_nt_element_open.
            DO.
              lo_reader->next_attribute( ).
              IF lo_reader->node_type <> if_sxml_node=>co_nt_attribute.
                EXIT.
              ENDIF.
              APPEND VALUE #(
                node_type  = `attribute`
                prefix     = lo_reader->prefix
                name       = lo_reader->name
                nsuri      = lo_reader->nsuri
                value      = lo_reader->value ) TO rt_data.
            ENDDO.
          ENDIF.
        ENDDO.
      CATCH cx_sxml_parse_error INTO DATA(parse_error).
    ENDTRY.
  ENDMETHOD.