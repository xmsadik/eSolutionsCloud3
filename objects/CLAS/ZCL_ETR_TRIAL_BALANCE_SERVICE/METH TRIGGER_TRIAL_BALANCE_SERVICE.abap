  METHOD trigger_trial_balance_service.
    DATA: url           TYPE string,
          select_value  TYPE string,
          lv_temp_datum TYPE datum,
          lv_temp_endda TYPE datum.

    get_service_info(  ).

    DATA(service_info) = VALUE #( mt_users[ 1 ] OPTIONAL ).

    service_info-service_url = 'https://' && zcl_etr_regulative_common=>get_api_url( ) && '/sap/opu/odata/sap/C_TRIALBALANCE_CDS/C_TRIALBALANCE'.

    IF iv_gjahr IS NOT INITIAL AND iv_monat IS NOT INITIAL.
      DATA(lv_filter_begda) = iv_gjahr && '-' && iv_monat && '-01T00:00:00'.
      DATA(lv_filter_endda) = lv_filter_begda.

      lv_temp_datum   = iv_gjahr && iv_monat && '01'.
      zinf_regulative_common=>rp_last_day_of_months(
        EXPORTING
          day_in            = lv_temp_datum
        IMPORTING
          last_day_of_month = lv_temp_endda
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).
      lv_filter_begda = lv_filter_begda(4) && |-| && lv_filter_begda+5(2) && |-| && lv_filter_begda+8(2) && |T00:00:00|.
      lv_filter_endda = lv_temp_endda(4) && |-| && lv_temp_endda+4(2) && |-| && lv_temp_endda+6(2) && |T00:00:00|.
    ENDIF.

    url = service_info-service_url && |(P_FromPostingDate=datetime| && |'| && lv_filter_begda && |',| && |P_ToPostingDate=datetime| && |'| && lv_filter_endda && |')/Results|.

    select_value = 'CompanyCode,GLAccount,DebitCreditCode,FiscalYearPeriod,StartingBalanceAmtInCoCodeCrcy,DebitAmountInCoCodeCrcy,DebitAmountInCoCodeCrcy_E,' &&
                    'CreditAmountInCoCodeCrcy,CreditAmountInCoCodeCrcy_E,EndingBalanceAmtInCoCodeCrcy,EndingBalanceAmtInCoCodeCrcy_E'.


    DATA(filter) = 'Ledger eq ' && |'{ iv_ledger }'| && | and CompanyCode eq |  && |'{ iv_company_code }'| .

    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( url ).
        DATA(lo_web_http_client)  = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

        lo_web_http_request->set_authorization_basic(
          EXPORTING
            i_username = CONV #( service_info-username )
            i_password = CONV #( service_info-password )
        ).

        lo_web_http_request->set_form_field(
          EXPORTING
            i_name  = '$filter'
            i_value = filter
        ).

        lo_web_http_request->set_form_field(
          EXPORTING
            i_name  = '$select'
            i_value = select_value
        ).

        lo_web_http_request->set_header_fields( VALUE #(
        ( name = 'DataServiceVersion' value = '2.0' )
        ( name = 'Accept'             value = 'application/xml' )
        ) ).

        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>get ).

        DATA(lv_response) = lo_web_http_response->get_text( ).

        zcl_etr_regulative_common=>parse_xml(
          EXPORTING
            iv_xml_string = lv_response
          RECEIVING
            rt_data       = DATA(lt_response_service)
        ).

        LOOP AT lt_response_service ASSIGNING FIELD-SYMBOL(<lfs_response_service>).
          CHECK <lfs_response_service>-node_type EQ 'CO_NT_VALUE'.
          CASE <lfs_response_service>-name .
            WHEN 'DebitAmountInCoCodeCrcy'.
              rs_balance-debits_per        = <lfs_response_service>-value + rs_balance-debits_per.
            WHEN 'CreditAmountInCoCodeCrcy'.
              rs_balance-credit_per          = <lfs_response_service>-value + rs_balance-credit_per.
          ENDCASE.
        ENDLOOP.
        rs_balance-comp_code = iv_company_code.
        rs_balance-fisc_year = iv_gjahr.
        rs_balance-fis_period = iv_monat.

      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_message) = lx_root->get_text( ).

    ENDTRY.
  ENDMETHOD.