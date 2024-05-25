  METHOD outgoing_invoice_send.
    DATA: lv_request_xml   TYPE string,
          lv_response_xml  TYPE string,
          lv_content       TYPE string,
          lv_ubl_raw       TYPE xstring,
          lv_document_uuid TYPE zetr_e_duich,
          lv_message       TYPE bapi_msg.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    DATA(lv_invoice_base64) = xco_cp=>xstring(  iv_ubl_xstring )->as_string( xco_cp_binary=>text_encoding->base64 )->value.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    lv_document_uuid = iv_document_uuid.
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
       '<ser:faturaOlustur>'
           '<input>'
              '{"vkn":"' mv_company_taxid '",'
              '"sube":"DFLT",'
              '"kasa":"DFLT",'
              '"islemId":"' lv_document_uuid '",'
              '"erpKodu":"' ls_custom_parameter-value '",'
              '"donenBelgeFormati":"9"}'
           '</input>'
           '<fatura>'
           '<belgeFormati>UBL</belgeFormati>'
           '<belgeIcerigi>' lv_invoice_base64 '</belgeIcerigi>'
           '</fatura>'
        '</ser:faturaOlustur>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).
    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    READ TABLE lt_xml_table INTO DATA(ls_xml_line) WITH KEY node_type = 'CO_NT_VALUE' name = 'belgeOid'.
    IF sy-subrc = 0.
      ev_integrator_uuid = ls_xml_line-value.
    ENDIF.

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY node_type = 'CO_NT_VALUE' name = 'resultCode'.
    IF sy-subrc = 0.
      IF ls_xml_line-value NE 'AE00000'.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY node_type = 'CO_NT_VALUE' name = 'resultText'.
        IF sy-subrc = 0.
          lv_message = ls_xml_line-value.
        ENDIF.

        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e004(zetr_common) WITH lv_message(50)
                                         lv_message+50(50)
                                         lv_message+100(50)
                                         lv_message+150(50).
      ENDIF.
    ENDIF.

    es_status-stacd = '5'.
  ENDMETHOD.