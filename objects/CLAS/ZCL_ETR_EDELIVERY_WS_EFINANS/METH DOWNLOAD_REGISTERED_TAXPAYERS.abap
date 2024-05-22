  METHOD download_registered_taxpayers.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          ls_user_list      TYPE mty_user_list,
          ls_user           TYPE mty_users,
          ls_alias          TYPE mty_user_alias,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE zetr_t_inv_ruser.
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
        '<ser:kayitliKullaniciListeleExtended>'
          '<urun>EIRSALIYE</urun>'
          '<gecmisEklensin></gecmisEklensin>'
        '</ser:kayitliKullaniciListeleExtended>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CASE ls_xml_line-name.
        WHEN 'return'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          CONCATENATE lv_base64_content ls_xml_line-value INTO lv_base64_content.
      ENDCASE.
    ENDLOOP.
    lv_zipped_file = xco_cp=>string( lv_base64_content )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
*    lv_zipped_file = cl_web_http_utility=>decode_base64( encoded = lv_base64_content ).
    zcl_etr_regulative_common=>unzip_file_single(
      EXPORTING
        iv_zipped_file_xstr = lv_zipped_file
      IMPORTING
        ev_output_data_str = lv_taxpayers_xml ).

    CLEAR lt_xml_table.
    lt_xml_table = zcl_etr_regulative_common=>parse_xml( iv_xml_string = lv_taxpayers_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
      CASE ls_xml_line-name.
        WHEN 'eIrsaliyeKayitliKullanici'.
          CLEAR ls_taxpayer.
        WHEN 'tip'.
          CASE ls_xml_line-value.
            WHEN 'Özel'.
              ls_taxpayer-txpty = 'OZEL'.
            WHEN OTHERS.
              ls_taxpayer-txpty = 'KAMU'.
          ENDCASE.
        WHEN 'kayitZamani'.
          ls_taxpayer-regdt = ls_xml_line-value(8).
          ls_taxpayer-regtm = ls_xml_line-value+8(6).
        WHEN 'unvan'.
          ls_taxpayer-title = ls_xml_line-value.
        WHEN 'vknTckn'.
          ls_taxpayer-taxid = ls_xml_line-value.
        WHEN 'etiket'.
          ls_taxpayer-aliass = ls_xml_line-value.
          APPEND ls_taxpayer TO rt_list.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.