  METHOD select_incinv_content.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_content.
    DATA(lo_paging) = io_request->get_paging( ).
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.
    READ TABLE lt_filter INTO DATA(ls_filter_docui) WITH KEY name = 'DOCUMENTUUID'.
    CHECK sy-subrc = 0.
    READ TABLE lt_filter INTO DATA(ls_filter_conty) WITH KEY name = 'CONTENTTYPE'.

    DATA(lv_document_uuid) = ls_filter_docui-range[ 1 ]-low.
    SELECT SINGLE docui, invno, bukrs
      FROM zetr_t_icinv
      WHERE docui = @lv_document_uuid
      INTO @DATA(ls_document).
    TRY.
        DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( ls_document-bukrs ).

        IF 'PDF' IN ls_filter_conty-range.
          APPEND INITIAL LINE TO lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
          <ls_output>-ContentType = 'PDF'.
          <ls_output>-MimeType = 'application/pdf'.
          <ls_output>-Filename = ls_document-invno && '.PDF'.
          <ls_output>-DocumentUUID = ls_document-docui.
          IF ls_filter_conty-range IS NOT INITIAL.
            <ls_output>-DocumentContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = ls_document-docui
                                                                                             iv_content_type = <ls_output>-ContentType
                                                                                             iv_create_log   = COND #( WHEN ls_filter_conty-range IS NOT INITIAL THEN abap_true ELSE abap_false ) ).
          ENDIF.
        ENDIF.

        IF 'HTML' IN ls_filter_conty-range.
          APPEND INITIAL LINE TO lt_output ASSIGNING <ls_output>.
          <ls_output>-ContentType = 'HTML'.
          <ls_output>-MimeType = 'text/html'.
          <ls_output>-Filename = ls_document-invno && '.HTML'.
          <ls_output>-DocumentUUID = ls_document-docui.
          IF ls_filter_conty-range IS NOT INITIAL.
            <ls_output>-DocumentContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = ls_document-docui
                                                                                             iv_content_type = <ls_output>-ContentType
                                                                                             iv_create_log   = COND #( WHEN ls_filter_conty-range IS NOT INITIAL THEN abap_true ELSE abap_false ) ).
          ENDIF.
        ENDIF.

        IF 'UBL' IN ls_filter_conty-range.
          APPEND INITIAL LINE TO lt_output ASSIGNING <ls_output>.
          <ls_output>-ContentType = 'UBL'.
          <ls_output>-MimeType = 'text/xml'.
          <ls_output>-Filename = ls_document-invno && '.XML'.
          <ls_output>-DocumentUUID = ls_document-docui.
          IF ls_filter_conty-range IS NOT INITIAL.
            <ls_output>-DocumentContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = ls_document-docui
                                                                                             iv_content_type = <ls_output>-ContentType
                                                                                             iv_create_log   = COND #( WHEN ls_filter_conty-range IS NOT INITIAL THEN abap_true ELSE abap_false ) ).
          ENDIF.
        ENDIF.
      CATCH zcx_etr_regulative_exception.
        "handle exception
    ENDTRY.

    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.