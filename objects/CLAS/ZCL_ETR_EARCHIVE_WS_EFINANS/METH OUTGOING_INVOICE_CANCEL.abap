  METHOD outgoing_invoice_cancel.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring,
          lv_status       TYPE zetr_e_descr255,
          lv_description  TYPE string,
          lv_message      TYPE bapi_msg.

    FIELD-SYMBOLS:  <lv_return_field> TYPE any.

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
       '<ser:faturaIptalEt>'
           '<input>'
              '{"faturaUuid":"' is_document_numbers-duich '"}'
           '</input>'
        '</ser:faturaIptalEt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
      CASE ls_xml_line-name.
        WHEN 'resultCode'.
          lv_status = ls_xml_line-value.
        WHEN 'resultText'.
          CONCATENATE lv_description ls_xml_line-value INTO lv_description.
      ENDCASE.
    ENDLOOP.
    IF lv_status <> 'AE00000'.
      lv_message = lv_description.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e004(zetr_common) WITH lv_message(50)
                                       lv_message+50(50)
                                       lv_message+100(50)
                                       lv_message+150(50).
    ENDIF.
  ENDMETHOD.