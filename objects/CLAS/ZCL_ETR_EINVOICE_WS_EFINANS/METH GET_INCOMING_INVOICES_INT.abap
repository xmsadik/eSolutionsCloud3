  METHOD get_incoming_invoices_int.
    DATA: lv_request_xml     TYPE string,
          lv_import_received TYPE string.
    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.
    lv_import_received = COND #( WHEN iv_import_received = abap_true THEN 'true' ).
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gelenBelgeleriAlExt>'
           '<parametreler>'
*              '<belgeFormati>UBL</belgeFormati>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<belgeVersiyon>2.0</belgeVersiyon>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<belgelerAlindiMi>' lv_import_received '</belgelerAlindiMi>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<gelisTarihiBaslangic>' iv_date_from '000000</gelisTarihiBaslangic>'
              '<gelisTarihiBitis>' iv_date_to '235959</gelisTarihiBitis>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
              '<ettn>' iv_invoice_uuid '</ettn>'
           '</parametreler>'
        '</ser:gelenBelgeleriAlExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    DATA(lv_response_xml) = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CASE ls_xml_line-name.
        WHEN 'return'.
          CHECK ls_xml_line-node_type = 'CO_NT_ELEMENT_OPEN'.
          APPEND INITIAL LINE TO rt_invoices ASSIGNING FIELD-SYMBOL(<ls_list>).
        WHEN 'belgeXmlZipped'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          CONCATENATE <ls_list>-belgexmlzipped
                      ls_xml_line-value
                      INTO <ls_list>-belgexmlzipped.
        WHEN OTHERS.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          TRANSLATE ls_xml_line-name TO UPPER CASE.
          ASSIGN COMPONENT ls_xml_line-name OF STRUCTURE <ls_list> TO FIELD-SYMBOL(<lv_invoice_field>).
          IF sy-subrc = 0.
            <lv_invoice_field> = ls_xml_line-value.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.