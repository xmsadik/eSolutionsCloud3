  METHOD get_incoming_deliveries.
    IF iv_date_from IS INITIAL OR iv_date_to IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e096(zetr_common).
    ENDIF.
    DATA(lt_service_return) = get_incoming_deliveries_int( iv_date_from = iv_date_from
                                                           iv_date_to = iv_date_to ).
    LOOP AT lt_service_return ASSIGNING FIELD-SYMBOL(<ls_service_return>).
      TRY.
          DATA(lv_uuid) = cl_system_uuid=>create_uuid_c22_static( ).
          APPEND INITIAL LINE TO et_list ASSIGNING FIELD-SYMBOL(<ls_list>).
          <ls_list>-docui = lv_uuid.
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <ls_list>-dlvui = <ls_service_return>-ettn.
      <ls_list>-dlvno = <ls_service_return>-belgeno.
      <ls_list>-dlvii = <ls_service_return>-belgesirano.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-dlvno = <ls_service_return>-belgeno.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-dlvii = <ls_service_return>-belgesirano.
      <ls_list>-dlvqi = <ls_service_return>-ettn.
      <ls_list>-bukrs = ms_company_parameters-bukrs.
      <ls_list>-taxid = <ls_service_return>-gonderenvkntckn.
      <ls_list>-bldat = <ls_service_return>-belgetarihi.

      DATA(ls_invoice_status) = get_incoming_delivery_stat_int( <ls_list>-dlvui ).
      <ls_list>-recdt = ls_invoice_status-alimtarihi(8).
      <ls_list>-staex = ls_invoice_status-yanitgonderimcevabidetayi.
      <ls_list>-radsc = ls_invoice_status-yanitgonderimcevabikodu.
      <ls_list>-ruuid = ls_invoice_status-yanitettn.
      IF <ls_list>-ruuid IS NOT INITIAL.
        TRY.
            cl_system_uuid=>convert_uuid_c36_static(
              EXPORTING
                uuid     = <ls_list>-ruuid
              IMPORTING
                uuid_c22 = <ls_list>-ruuidc ).
          CATCH cx_uuid_error.
        ENDTRY.
      ENDIF.
      CASE ls_invoice_status-yanitdurumu.
        WHEN '0'.
          <ls_list>-resst = '0'.
        WHEN '-1'.
          <ls_list>-resst = 'X'.
        WHEN '1' OR '2'.
          <ls_list>-resst = '1'.
        WHEN OTHERS.
          CLEAR <ls_list>-resst.
      ENDCASE.

      DATA(lv_zipped_file) = xco_cp=>string( <ls_service_return>-belgexmlzipped )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
      zcl_etr_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_zipped_file
        IMPORTING
          ev_output_data_str = DATA(lv_document_xml) ).
      DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_document_xml ).
      LOOP AT lt_xml_table INTO DATA(ls_xml_line).
        CASE ls_xml_line-name.
          WHEN 'irsaliyeSatir'.
            CHECK ls_xml_line-node_type = 'CO_NT_ELEMENT_OPEN'.
            DATA(lv_item_index) = sy-tabix + 1.
            APPEND INITIAL LINE TO et_items ASSIGNING FIELD-SYMBOL(<ls_item>).
            <ls_item>-docui = <ls_list>-docui.
            LOOP AT lt_xml_table INTO DATA(ls_xml_item) FROM lv_item_index.
              CASE ls_xml_item-name.
                WHEN 'irsaliyeSatir'.
                  CHECK ls_xml_line-node_type = 'CO_NT_ELEMENT_CLOSE'.
                  UNASSIGN <ls_item>.
                  EXIT.
                WHEN 'paraBirimi'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-waers = ls_xml_item-value.
                WHEN 'siraNo'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-linno IS INITIAL.
                  <ls_item>-linno = ls_xml_item-value.
                WHEN 'gonderilenMalAdedi'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-menge = ls_xml_item-value.
                WHEN 'birimKodu'.
                  CHECK ls_xml_item-node_type = 'attribute' AND <ls_item>-meins IS INITIAL.
                  SELECT SINGLE meins
                    FROM zetr_t_untmc
                    WHERE unitc = @ls_xml_item-value
                    INTO @<ls_item>-meins.
                WHEN 'aciklama'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-descr IS INITIAL.
                  <ls_item>-descr = ls_xml_item-value.
                WHEN 'adi'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-mdesc IS INITIAL.
                  <ls_item>-mdesc = ls_xml_item-value.
                WHEN 'aliciUrunKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-buyii = ls_xml_item-value.
                WHEN 'saticiUrunKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-selii = ls_xml_item-value.
                WHEN 'ureticiUrunKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-manii = ls_xml_item-value.
                WHEN 'birimFiyat'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-netpr IS INITIAL.
                  <ls_item>-netpr = ls_xml_item-value.
              ENDCASE.
            ENDLOOP.
          WHEN 'irsaliyeTuru'.
            CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
            <ls_list>-prfid = ls_xml_line-value(5).
          WHEN 'urunDegeri'.
            CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
            <ls_list>-wrbtr = ls_xml_line-value.
          WHEN 'irsaliyeTipi'.
            CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
            <ls_list>-dlvty = ls_xml_line-value.
          WHEN 'paraBirimi'.
            IF <ls_item> IS NOT ASSIGNED AND ls_xml_line-node_type = 'CO_NT_VALUE'.
              <ls_list>-waers = ls_xml_line-value.
            ENDIF.
        ENDCASE.
      ENDLOOP.

      set_incoming_delivery_received( <ls_list>-dlvui ).
    ENDLOOP.
  ENDMETHOD.