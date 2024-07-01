  METHOD run_service.
    DATA: lv_length_text TYPE string,
          lv_message     TYPE bapi_msg.

    DATA(lv_request_length) = strlen( iv_request ).
    lv_length_text = lv_request_length.
    CONDENSE lv_length_text.

    IF iv_use_alternative_endpoint = abap_true.
      DATA(lv_endpoint) = CONV string( ms_company_parameters-wsena ).
    ELSE.
      lv_endpoint = ms_company_parameters-wsend.
    ENDIF.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_endpoint ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e004(zetr_common).
        ENDIF.

        IF iv_authenticate IS NOT INITIAL.
          lo_request->set_authorization_basic(
            EXPORTING
              i_username = CONV #( ms_company_parameters-wsusr )
              i_password = CONV #( ms_company_parameters-wspwd ) ).
        ENDIF.

        lo_request->set_header_field( i_name  = '~request_method'
                                      i_value = 'POST' ).

        IF mv_request_url IS NOT INITIAL.
          lo_request->set_header_field( i_name  = '~request_uri'
                                        i_value = mv_request_url ).
        ENDIF.

        lo_request->set_header_field( i_name  = 'Content-Length'
                                      i_value = lv_length_text ).

        IF it_request_header IS NOT INITIAL.
          LOOP AT it_request_header INTO DATA(ls_request_header).
            lo_request->set_header_field( i_name  = ls_request_header-name
                                          i_value = ls_request_header-value ).
          ENDLOOP.
        ELSE.
          lo_request->set_header_field( i_name  = 'Content-Type'
                                        i_value = 'text/xml; charset=utf-8' ).
        ENDIF.

        lo_request->set_text( i_text   = iv_request
                              i_offset = 0
                              i_length = -1 ).

        DATA(lo_response) = lo_http_client->execute( i_method  = if_web_http_client=>post ).
        rv_response = lo_response->get_text( ).
        IF rv_response IS INITIAL.
          DATA(ls_response) = lo_response->get_status( ).
          lv_message = ls_response-code.
          CONDENSE lv_message.
          CONCATENATE lv_message ls_response-reason INTO lv_message SEPARATED BY '-'.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e000(zetr_common) WITH lv_message(50)
                                           lv_message+50(50)
                                           lv_message+100(50)
                                           lv_message+150(50).
        ELSEIF rv_response CS 'faultstring'.
          DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( rv_response ).
          LOOP AT lt_xml_table INTO DATA(ls_xml_line).
            CASE ls_xml_line-name.
              WHEN 'faultstring'.
                CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
                CONCATENATE lv_message ls_xml_line-value INTO lv_message.
            ENDCASE.
          ENDLOOP.
*          FIND REGEX 'faultstring:.*''.*''' IN rv_response SUBMATCHES lv_message.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e000(zetr_common) WITH lv_message(50)
                                           lv_message+50(50)
                                           lv_message+100(50)
                                           lv_message+150(50).
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