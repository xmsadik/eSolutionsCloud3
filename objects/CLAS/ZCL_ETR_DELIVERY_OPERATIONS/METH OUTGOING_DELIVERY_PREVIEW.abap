  METHOD outgoing_delivery_preview.
    DATA(lv_endpoint) = CONV string( '' ).
    DATA(lv_ws_user) = CONV string( '' ).
    DATA(lv_ws_password) = CONV string( '' ).
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_endpoint ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e004(zetr_common).
        ENDIF.

        lo_request->set_authorization_basic(
          EXPORTING
            i_username = lv_ws_user
            i_password = lv_ws_password ).

        lo_request->set_header_field( i_name  = '~request_method'
                                      i_value = 'POST' ).

        lo_request->set_header_field( i_name  = 'Content-Type'
                                      i_value = 'text/xml; charset=utf-8' ).

        lo_request->set_binary(
          EXPORTING
            i_data   = iv_document_ubl
            i_length = xstrlen( iv_document_ubl ) ).

        DATA(lo_response) = lo_http_client->execute( i_method  = if_web_http_client=>post ).
        DATA(lv_response) = lo_response->get_text( ).
        IF lv_response IS INITIAL.
          DATA(ls_response) = lo_response->get_status( ).
          DATA(lv_message) = CONV bapi_msg( ls_response-code ).
          CONDENSE lv_message.
          CONCATENATE lv_message ls_response-reason INTO lv_message SEPARATED BY '-'.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e000(zetr_common) WITH lv_message(50)
                                           lv_message+50(50)
                                           lv_message+100(50)
                                           lv_message+150(50).
        ELSE.
*          rv_document = lv_response.
*          rv_document = xco_cp=>string( lv_response )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
*          DATA(lv_decoded_data) = cl_web_http_utility=>decode_base64( encoded = lv_response ).
          rv_delivery_data = cl_abap_conv_codepage=>create_out( )->convert(
              replace( val = lv_response
                       sub = |\n|
                       with = ``
                       occ = 0  ) ).
        ENDIF.
      CATCH cx_http_dest_provider_error INTO DATA(lx_http_dest_provider_error).
        lv_message = lx_http_dest_provider_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e000(zetr_common) WITH lv_message(50)
                                         lv_message+50(50)
                                         lv_message+100(50)
                                         lv_message+150(50).
      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        lv_message = lx_web_http_client_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e000(zetr_common) WITH lv_message(50)
                                         lv_message+50(50)
                                         lv_message+100(50)
                                         lv_message+150(50).
    ENDTRY.
  ENDMETHOD.