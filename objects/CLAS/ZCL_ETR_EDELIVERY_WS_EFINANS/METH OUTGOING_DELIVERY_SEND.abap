  METHOD outgoing_delivery_send.
    DATA: lv_request_xml TYPE string,
          lv_alliass     TYPE string.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    DATA(lv_delivery_base64) = xco_cp=>xstring(  iv_ubl_xstring )->as_string( xco_cp_binary=>text_encoding->base64 )->value.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    IF iv_receiver_alias IS NOT INITIAL.
      CONCATENATE '<alanEtiket>' iv_receiver_alias '</alanEtiket>' INTO lv_alliass.
    ENDIF.

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
              lv_alliass
              '<belgeHash>' iv_ubl_hash '</belgeHash>'
              '<belgeNo>' iv_document_uuid '</belgeNo>'
              '<belgeVersiyon>2.1</belgeVersiyon>'
              '<belgeTuru>IRSALIYE_UBL</belgeTuru>'
              '<mimeType>application/xml</mimeType>'
              '<veri>' lv_delivery_base64 '</veri>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:belgeGonderExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    DATA(lv_response_xml) = run_service( lv_request_xml ).
    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    READ TABLE lt_xml_table INTO DATA(ls_xml_line) WITH KEY node_type = 'CO_NT_VALUE' name = 'belgeOid'.
    IF sy-subrc = 0.
      DO 5 TIMES.
        CLEAR es_status.
        TRY.
            es_status = outgoing_delivery_get_status( VALUE #( docii = ls_xml_line-value ) ).
          CATCH cx_root.
        ENDTRY.
        IF es_status-stacd = 1 OR es_status IS INITIAL.
          WAIT UP TO 1 SECONDS.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
      IF es_status-stacd = '2'.
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e004(zetr_common)
            WITH es_status-staex(50) es_status-staex+50(50) es_status-staex+100(50) es_status-staex+150(*).
      ELSE.
        ev_integrator_uuid = ls_xml_line-value.
      ENDIF.
    ENDIF.
  ENDMETHOD.