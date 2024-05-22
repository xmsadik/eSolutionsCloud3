  METHOD get_incoming_invoices.
    IF iv_date_from IS INITIAL OR iv_date_to IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e096(zetr_common).
    ENDIF.
    DATA(lt_service_return) = get_incoming_invoices_int( iv_date_from = iv_date_from
                                                         iv_date_to = iv_date_to ).
    LOOP AT lt_service_return ASSIGNING FIELD-SYMBOL(<ls_service_return>).
      TRY.
          DATA(lv_uuid) = cl_system_uuid=>create_uuid_c22_static( ).
          APPEND INITIAL LINE TO rt_list ASSIGNING FIELD-SYMBOL(<ls_list>).
          <ls_list>-docui = lv_uuid.
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <ls_list>-invui = <ls_service_return>-ettn.
      <ls_list>-invno = <ls_service_return>-belgeno.
      <ls_list>-invii = <ls_service_return>-belgesirano.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-invno = <ls_service_return>-belgeno.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-invii = <ls_service_return>-belgesirano.
      <ls_list>-invqi = <ls_service_return>-ettn.
      <ls_list>-bukrs = ms_company_parameters-bukrs.
      <ls_list>-taxid = <ls_service_return>-gonderenvkntckn.
      <ls_list>-bldat = <ls_service_return>-belgetarihi.

      DATA(ls_invoice_status) = get_incoming_invoice_stat_int( <ls_list>-invui ).
      <ls_list>-recdt = ls_invoice_status-alimtarihi(8).
      <ls_list>-staex = ls_invoice_status-yanitgonderimcevabidetayi.
      <ls_list>-radsc = ls_invoice_status-yanitgonderimcevabikodu.
      IF ls_invoice_status-kepdurum = '1'.
        <ls_list>-resst = 'K'.
      ELSEIF ls_invoice_status-gibiptaldurum = '1'.
        <ls_list>-resst = 'G'.
      ELSEIF ls_invoice_status-yanitdurumu = '-1'.
        <ls_list>-resst = 'X'.
      ELSE.
        <ls_list>-resst = ls_invoice_status-yanitdurumu.
      ENDIF.

      DATA(lv_zipped_file) = xco_cp=>string( <ls_service_return>-belgexmlzipped )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
      zcl_etr_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_zipped_file
        IMPORTING
          ev_output_data_str = DATA(lv_document_xml) ).
      DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_document_xml ).
      LOOP AT lt_xml_table INTO DATA(ls_xml_line).
        CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
        CASE ls_xml_line-name.
          WHEN 'faturaTuru'.
            <ls_list>-prfid = zcl_etr_invoice_operations=>conversion_profile_id_input( ls_xml_line-value ).
          WHEN 'faturaTipi'.
            <ls_list>-invty = zcl_etr_invoice_operations=>conversion_invoice_type_input( ls_xml_line-value ).
          WHEN 'kur'.
            <ls_list>-kursf = ls_xml_line-value.
          WHEN 'paraBirimi'.
            <ls_list>-waers = ls_xml_line-value.
          WHEN 'odenecekTutar'.
            <ls_list>-wrbtr = ls_xml_line-value.
          WHEN 'vergiDahilTutar'.
            <ls_list>-fwste += ls_xml_line-value.
          WHEN 'vergiHaricToplam'.
            <ls_list>-fwste -= ls_xml_line-value.
        ENDCASE.
      ENDLOOP.

      set_incoming_invoice_received( <ls_list>-invui ).
    ENDLOOP.
  ENDMETHOD.