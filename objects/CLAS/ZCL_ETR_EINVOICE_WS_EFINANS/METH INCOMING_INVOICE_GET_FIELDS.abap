  METHOD incoming_invoice_get_fields.
    DATA: lv_xml_tag   TYPE string,
          lv_regex     TYPE string,
          lv_submatch  TYPE string,
          lv_tab_field TYPE string.
    LOOP AT it_xml_table INTO DATA(ls_xml_line).
      CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
      CASE ls_xml_line-name.
        WHEN 'faturaTuru'.
          cs_invoice-prfid = zcl_etr_invoice_operations=>conversion_profile_id_input( ls_xml_line-value ).
        WHEN 'faturaTipi'.
          cs_invoice-invty = zcl_etr_invoice_operations=>conversion_invoice_type_input( ls_xml_line-value ).
        WHEN 'kur'.
          cs_invoice-kursf = ls_xml_line-value.
        WHEN 'paraBirimi'.
          cs_invoice-waers = ls_xml_line-value.
        WHEN 'odenecekTutar'.
          cs_invoice-wrbtr = ls_xml_line-value.
        WHEN 'vergiDahilTutar'.
          cs_invoice-fwste += ls_xml_line-value.
        WHEN 'vergiHaricToplam'.
          cs_invoice-fwste -= ls_xml_line-value.
        WHEN OTHERS.
          CHECK line_exists( mt_custom_parameters[ KEY by_cuspa COMPONENTS cuspa = 'INCINVFLD' ] ).
          LOOP AT mt_custom_parameters INTO DATA(ls_custom_parameter) USING KEY by_cuspa WHERE cuspa = 'INCINVFLD'.
            CLEAR: lv_xml_tag, lv_regex, lv_tab_field, lv_submatch.
            SPLIT ls_custom_parameter-value AT '/' INTO lv_xml_tag lv_regex lv_tab_field.
            CHECK lv_xml_tag IS NOT INITIAL AND
                  lv_tab_field IS NOT INITIAL AND
                  lv_xml_tag = ls_xml_line-name.
            IF lv_regex IS NOT INITIAL.
              FIND REGEX lv_regex IN ls_xml_line-value SUBMATCHES lv_submatch.
            ELSE.
              lv_submatch = ls_xml_line-value.
            ENDIF.
            ASSIGN COMPONENT lv_tab_field OF STRUCTURE cs_invoice TO FIELD-SYMBOL(<ls_field>).
            IF sy-subrc = 0.
              <ls_field> = lv_submatch.
            ENDIF.
          ENDLOOP.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.