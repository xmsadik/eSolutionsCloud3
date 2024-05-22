  METHOD build_application_response.
    DATA(lv_delivery_ubl) = incoming_delivery_download( is_document_numbers = is_document_numbers
                                                        iv_content_type     = 'UBL' ).

    TRY.
        DATA(lv_xml_string) = cl_abap_conv_codepage=>create_in( )->convert( lv_delivery_ubl ).
        DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_xml_string ).

        LOOP AT lt_xml_table INTO DATA(ls_xml_line).
          DATA(lv_index) = sy-tabix.
          CASE ls_xml_line-name.
            WHEN 'UBLVersionID'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
              es_response_structure-ublversionid-content = ls_xml_line-value.
            WHEN 'CustomizationID'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
              es_response_structure-customizationid-content = ls_xml_line-value.
            WHEN 'ProfileID'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
              es_response_structure-profileid-content = ls_xml_line-value.
            WHEN 'ID'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE' AND es_response_structure-id-content IS INITIAL.
              es_response_structure-id-content = ls_xml_line-value.
            WHEN 'DespatchAdviceTypeCode'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
              es_response_structure-receiptadvicetypecode-content = ls_xml_line-value.
            WHEN 'IssueDate'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
              es_response_structure-despatchdocumentreference-issuedate-content = ls_xml_line-value.
            WHEN 'UUID'.
              CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
              es_response_structure-despatchdocumentreference-id-content = ls_xml_line-value.
            WHEN 'DeliveryCustomerParty'.
              CASE ls_xml_line-node_type.
                WHEN 'CO_NT_ELEMENT_OPEN'.
                  DATA(lv_from) = lv_index + 1.
                  LOOP AT lt_xml_table INTO DATA(ls_xml_line_temp) FROM lv_from.
                    CASE ls_xml_line_temp-name.
                      WHEN 'DeliveryCustomerParty'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_CLOSE'.
                        EXIT.
                      WHEN 'PartyIdentification'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          APPEND INITIAL LINE TO es_response_structure-DeliveryCustomerParty-party-partyidentification ASSIGNING FIELD-SYMBOL(<ls_identification>).
                        ELSEIF <ls_identification> IS ASSIGNED.
                          UNASSIGN <ls_identification>.
                        ENDIF.
                      WHEN 'schemeID'.
                        CHECK <ls_identification> IS ASSIGNED.
                        <ls_identification>-schemeid = ls_xml_line_temp-value.
                      WHEN 'ID'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'
                          AND <ls_identification> IS ASSIGNED..
                        <ls_identification>-content = ls_xml_line_temp-value.
                      WHEN 'PartyName'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-DeliveryCustomerParty-party-partyname TO FIELD-SYMBOL(<ls_partyname>).
                        ELSEIF <ls_partyname> IS ASSIGNED.
                          UNASSIGN <ls_partyname>.
                        ENDIF.
                      WHEN 'Country'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-DeliveryCustomerParty-party-postaladdress-country TO FIELD-SYMBOL(<ls_country>).
                        ELSEIF <ls_country> IS ASSIGNED.
                          UNASSIGN <ls_country>.
                        ENDIF.
                      WHEN 'TaxScheme'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-DeliveryCustomerParty-party-partytaxscheme-taxscheme-name TO FIELD-SYMBOL(<ls_taxscheme>).
                        ELSEIF <ls_taxscheme> IS ASSIGNED.
                          UNASSIGN <ls_taxscheme>.
                        ENDIF.
                      WHEN 'Name'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        IF <ls_partyname> IS ASSIGNED.
                          <ls_partyname> = ls_xml_line_temp-value.
                        ELSEIF <ls_country> IS ASSIGNED.
                          <ls_country> = ls_xml_line_temp-value.
                        ELSEIF <ls_taxscheme> IS ASSIGNED.
                          <ls_taxscheme> = ls_xml_line_temp-value.
                        ENDIF.
                      WHEN 'CitySubdivisionName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DeliveryCustomerParty-party-postaladdress-citysubdivisionname-content = ls_xml_line_temp-value.
                      WHEN 'CityName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DeliveryCustomerParty-party-postaladdress-cityname-content = ls_xml_line_temp-value.
                      WHEN 'CityName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DeliveryCustomerParty-party-postaladdress-cityname-content = ls_xml_line_temp-value.
                      WHEN 'FirstName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DeliveryCustomerParty-party-person-firstname-content = ls_xml_line_temp-value.
                      WHEN 'FamilyName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DeliveryCustomerParty-party-person-familyname-content = ls_xml_line_temp-value.
                    ENDCASE.
                  ENDLOOP.
              ENDCASE.
            WHEN 'DespatchSupplierParty'.
              CASE ls_xml_line-node_type.
                WHEN 'CO_NT_ELEMENT_OPEN'.
                  lv_from = lv_index + 1.
                  LOOP AT lt_xml_table INTO ls_xml_line_temp FROM lv_from.
                    CASE ls_xml_line_temp-name.
                      WHEN 'DespatchSupplierParty'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_CLOSE'.
                        EXIT.
                      WHEN 'PartyIdentification'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          APPEND INITIAL LINE TO es_response_structure-DespatchSupplierParty-party-partyidentification ASSIGNING <ls_identification>.
                        ELSEIF <ls_identification> IS ASSIGNED.
                          UNASSIGN <ls_identification>.
                        ENDIF.
                      WHEN 'schemeID'.
                        CHECK <ls_identification> IS ASSIGNED.
                        <ls_identification>-schemeid = ls_xml_line_temp-value.
                      WHEN 'ID'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'
                          AND <ls_identification> IS ASSIGNED..
                        <ls_identification>-content = ls_xml_line_temp-value.
                      WHEN 'PartyName'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-DespatchSupplierParty-party-partyname TO <ls_partyname>.
                        ELSEIF <ls_partyname> IS ASSIGNED.
                          UNASSIGN <ls_partyname>.
                        ENDIF.
                      WHEN 'Country'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-DespatchSupplierParty-party-postaladdress-country TO <ls_country>.
                        ELSEIF <ls_country> IS ASSIGNED.
                          UNASSIGN <ls_country>.
                        ENDIF.
                      WHEN 'TaxScheme'.
                        IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                          ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-DespatchSupplierParty-party-partytaxscheme-taxscheme-name TO <ls_taxscheme>.
                        ELSEIF <ls_taxscheme> IS ASSIGNED.
                          UNASSIGN <ls_taxscheme>.
                        ENDIF.
                      WHEN 'Name'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        IF <ls_partyname> IS ASSIGNED.
                          <ls_partyname> = ls_xml_line_temp-value.
                        ELSEIF <ls_country> IS ASSIGNED.
                          <ls_country> = ls_xml_line_temp-value.
                        ELSEIF <ls_taxscheme> IS ASSIGNED.
                          <ls_taxscheme> = ls_xml_line_temp-value.
                        ENDIF.
                      WHEN 'CitySubdivisionName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DespatchSupplierParty-party-postaladdress-citysubdivisionname-content = ls_xml_line_temp-value.
                      WHEN 'CityName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DespatchSupplierParty-party-postaladdress-cityname-content = ls_xml_line_temp-value.
                      WHEN 'CityName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DespatchSupplierParty-party-postaladdress-cityname-content = ls_xml_line_temp-value.
                      WHEN 'FirstName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DespatchSupplierParty-party-person-firstname-content = ls_xml_line_temp-value.
                      WHEN 'FamilyName'.
                        CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                        es_response_structure-DespatchSupplierParty-party-person-familyname-content = ls_xml_line_temp-value.
                    ENDCASE.
                  ENDLOOP.
              ENDCASE.
          ENDCASE.
        ENDLOOP.

        es_response_structure-copyindicator-content = 'false'.
        es_response_structure-uuid-content = cl_system_uuid=>create_uuid_c36_static( ).
        DATA(lv_datum) = cl_abap_context_info=>get_system_date( ).
        DATA(lv_uzeit) = cl_abap_context_info=>get_system_time( ).
        CONCATENATE lv_datum+0(4)
                    lv_datum+4(2)
                    lv_datum+6(2)
          INTO es_response_structure-issuedate-content
          SEPARATED BY '-'.
        CONCATENATE lv_uzeit+0(2)
                    lv_uzeit+2(2)
                    lv_uzeit+4(2)
          INTO es_response_structure-issuetime-content
          SEPARATED BY ':'.
        APPEND INITIAL LINE TO es_response_structure-note ASSIGNING FIELD-SYMBOL(<ls_note>).
        <ls_note>-content = is_response_data-notes.
        APPEND INITIAL LINE TO es_response_structure-signature ASSIGNING FIELD-SYMBOL(<ls_signature>).
        <ls_signature>-id-schemeid = 'VKN_TCKN'.
        <ls_signature>-id-content = mv_company_taxid.
        <ls_signature>-signatoryparty = CORRESPONDING #( es_response_structure-deliverycustomerparty-party ).
        <ls_signature>-digitalsignatureattachment-externalreference-uri-content = 'Signature_DSB2022000000874'.

        LOOP AT it_response_items INTO DATA(ls_response_item).
          APPEND INITIAL LINE TO es_response_structure-receiptline ASSIGNING FIELD-SYMBOL(<ls_receipt_line>).
          <ls_receipt_line>-id-content = ls_response_item-linno.
          SHIFT <ls_receipt_line>-id-content LEFT DELETING LEADING '0'.
          CONDENSE <ls_receipt_line>-id-content.
          <ls_receipt_line>-item-sellersitemidentification-id-content = ls_response_item-selii.
          <ls_receipt_line>-item-manufacturersitemidentificatio-id-content = ls_response_item-manii.
          <ls_receipt_line>-item-buyersitemidentification-id-content = ls_response_item-buyii.
          <ls_receipt_line>-item-description-content = ls_response_item-descr.
          <ls_receipt_line>-item-name-content = ls_response_item-mdesc.
          <ls_receipt_line>-despatchlinereference-lineid-content = <ls_receipt_line>-id-content.
          SELECT SINGLE unitc
            FROM zetr_t_untmc
            WHERE meins = @ls_response_item-meins
            INTO @DATA(lv_unit_code).
          IF ls_response_item-recqt IS NOT INITIAL.
            <ls_receipt_line>-receivedquantity-content = ls_response_item-recqt.
            <ls_receipt_line>-receivedquantity-unitcode = lv_unit_code.
          ENDIF.
          IF ls_response_item-napqt IS NOT INITIAL.
            <ls_receipt_line>-rejectedquantity-content = ls_response_item-napqt.
            <ls_receipt_line>-rejectedquantity-unitcode = lv_unit_code.
          ENDIF.
          IF ls_response_item-misqt IS NOT INITIAL.
            <ls_receipt_line>-shortquantity-content = ls_response_item-misqt.
            <ls_receipt_line>-shortquantity-unitcode = lv_unit_code.
          ENDIF.
          IF ls_response_item-ovsqt IS NOT INITIAL.
            <ls_receipt_line>-oversupplyquantity-content = ls_response_item-ovsqt.
            <ls_receipt_line>-oversupplyquantity-unitcode = lv_unit_code.
          ENDIF.
        ENDLOOP.
        CALL TRANSFORMATION zetr_ubl21_receiptadvice
          SOURCE root = es_response_structure
          RESULT XML ev_response_xml.
        ev_response_hash = zcl_etr_regulative_common=>calculate_hash_for_raw( ev_response_xml ).
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_error) = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.