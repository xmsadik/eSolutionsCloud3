  METHOD outgoing_invoice_download.
    DATA: lv_request_xml     TYPE string,
          lv_response_xml    TYPE string,
          lv_content         TYPE string,
          lv_content_type(1).

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CASE iv_content_type.
      WHEN 'PDF'.
        lv_content_type = '3'.
      WHEN 'UBL'.
        lv_content_type = '0'.
      WHEN 'HTML'.
        lv_content_type = '2'.
    ENDCASE.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:faturaSorgula>'
           '<input>'
              '{"faturaUuid":"' is_document_numbers-duich '",'
              '"vkn":"' mv_company_taxid '",'
              '"donenBelgeFormati":"' lv_content_type '"}'
           '</input>'
        '</ser:faturaSorgula>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
      CASE ls_xml_line-name.
        WHEN 'belgeIcerigi'.
          CONCATENATE lv_content
              ls_xml_line-value
              INTO lv_content.
      ENDCASE.
    ENDLOOP.
    IF lv_content IS NOT INITIAL.
      rv_invoice_data = xco_cp=>string( lv_content )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
    ENDIF.
  ENDMETHOD.