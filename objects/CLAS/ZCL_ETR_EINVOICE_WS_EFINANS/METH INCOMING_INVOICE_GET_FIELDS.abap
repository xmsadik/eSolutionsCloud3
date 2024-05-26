  METHOD incoming_invoice_get_fields.
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
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.