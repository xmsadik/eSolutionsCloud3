  METHOD outgoing_invoice_get_status.
    TYPES: BEGIN OF ty_status,
             resultcode TYPE string,
             resulttext TYPE string,
           END OF ty_status.

    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring,
          ls_status       TYPE ty_status.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

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
              '"donenBelgeFormati":"9"}'
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
      TRANSLATE ls_xml_line-name TO UPPER CASE.
      ASSIGN COMPONENT ls_xml_line-name OF STRUCTURE ls_status TO <lv_return_field>.
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-value.
      ENDIF.
    ENDLOOP.

    IF ls_status-resultcode EQ 'AE00000'. "İşlem başarılı
      rs_status-stacd = 'X'.
    ELSE.
      rs_status-stacd = '2'.
    ENDIF.
    rs_status-staex = ls_status-resulttext.
  ENDMETHOD.