  METHOD outgoing_delivery_get_status.
    TYPES: BEGIN OF ty_status,
             aciklama                TYPE string,
             alimtarihi              TYPE string,
             belgeno                 TYPE string,
             durum                   TYPE string,
             ettn                    TYPE string,
             gonderimcevabidetayi    TYPE string,
             gonderimcevabikodu      TYPE string,
             gonderimdurumu          TYPE string,
             gonderimtarihi          TYPE string,
             olusturulmatarihi       TYPE string,
             yanitdetayi             TYPE string,
             yanitdurumu             TYPE string,
             yenidengonderilebilirmi TYPE string,
             yerelbelgeoid           TYPE string,
             yanitettn               TYPE string,
           END OF ty_status.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          ls_status       TYPE ty_status.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

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
       '<ser:gidenBelgeDurumSorgulaExt>'
           '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '<parametreler>'
              '<belgeNo>' is_document_numbers-docii '</belgeNo>'
              '<belgeNoTipi>OID</belgeNoTipi>'
              '<belgeTuru>IRSALIYE</belgeTuru>'
              '<donusTipiVersiyon>6.0</donusTipiVersiyon>'
           '</parametreler>'
        '</ser:gidenBelgeDurumSorgulaExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
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

    IF ls_status-durum = 1 OR ls_status-durum = 2.
      rs_status-stacd = ls_status-durum.
    ELSEIF ls_status-gonderimdurumu = 0.
      rs_status-stacd = '3'.
    ELSEIF ls_status-gonderimdurumu = -1 OR ls_status-gonderimdurumu = 1.
      rs_status-stacd = '4'.
    ELSEIF ls_status-gonderimdurumu = 2.
      rs_status-stacd = '5'.
    ELSEIF ls_status-gonderimdurumu = 3.
      rs_status-stacd = '6'.
    ELSEIF ls_status-gonderimdurumu = 4.
      IF ls_status-yanitdurumu = 0.
        rs_status-stacd = '7'.
      ELSE.
        rs_status-stacd = 'X'.
      ENDIF.
    ENDIF.
    IF ls_status-aciklama IS NOT INITIAL.
      rs_status-staex = ls_status-aciklama.
    ELSE.
      rs_status-staex = ls_status-gonderimcevabidetayi.
    ENDIF.
    CASE ls_status-yanitdurumu.
      WHEN '0' OR '1'.
        rs_status-resst = ls_status-yanitdurumu.
      WHEN OTHERS.
        rs_status-resst = ''.
    ENDCASE.
    IF ls_status-yenidengonderilebilirmi = 'true'.
      rs_status-rsend = abap_true.
    ELSE.
      rs_status-radsc = abap_false.
    ENDIF.
    rs_status-radsc = ls_status-gonderimcevabikodu.
    rs_status-dlvno = ls_status-belgeno.
    rs_status-dlvui = ls_status-ettn.
    rs_status-dlvqi = ls_status-ettn.
    rs_status-ruuid = ls_status-yanitettn.
  ENDMETHOD.