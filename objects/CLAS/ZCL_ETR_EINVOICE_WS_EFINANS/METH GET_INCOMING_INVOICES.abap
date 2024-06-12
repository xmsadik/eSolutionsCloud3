  METHOD get_incoming_invoices.
    IF iv_date_from IS INITIAL OR iv_date_to IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e096(zetr_common).
    ENDIF.
    DATA(lt_service_return) = get_incoming_invoices_int( iv_date_from = iv_date_from
                                                         iv_date_to = iv_date_to
                                                         iv_import_received = iv_import_received
                                                         iv_invoice_uuid = iv_invoice_uuid ).
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
      incoming_invoice_get_fields(
        EXPORTING
          it_xml_table = lt_xml_table
        CHANGING
          cs_invoice   = <ls_list> ).

      set_incoming_invoice_received( <ls_list>-invui ).
    ENDLOOP.
  ENDMETHOD.