  METHOD incoming_delivery_response.
    build_application_response(
      EXPORTING
        is_document_numbers = is_document_numbers
        is_response_data    = is_response_data
        it_response_items   = it_response_items
      IMPORTING
        ev_response_xml     = DATA(lv_appres_xml)
        ev_response_hash    = DATA(lv_appres_hash) ).

    DATA(lv_appres_base64) = xco_cp=>xstring(  lv_appres_xml )->as_string( xco_cp_binary=>text_encoding->base64 )->value.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    DATA lv_request_xml TYPE string.
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
       '<ser:belgeGonderExt>'
           '<parametreler>'
              '<belgeHash>' lv_appres_hash '</belgeHash>'
              '<belgeNo>' is_document_numbers-duich '</belgeNo>'
              '<belgeVersiyon>2.1</belgeVersiyon>'
              '<belgeTuru>IRSALIYE_YANITI_UBL</belgeTuru>'
              '<mimeType>application/xml</mimeType>'
              '<veri>' lv_appres_base64 '</veri>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:belgeGonderExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
**    mv_request_url = '/efatura/ws/connectorService'.
    DATA(lv_response_xml) = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
  ENDMETHOD.