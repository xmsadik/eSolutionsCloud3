  METHOD build_application_response.
    DATA(lv_invoice_xml) = me->incoming_invoice_download(
      EXPORTING
        is_document_numbers = is_document_numbers
        iv_content_type = 'UBL' ).
    DATA(lv_xml_string) = cl_abap_conv_codepage=>create_in( )->convert( lv_invoice_xml ).
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
        WHEN 'UUID'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-uuid-content = ls_xml_line-value.
        WHEN 'IssueDate'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-issuedate-content = ls_xml_line-value.
        WHEN 'IssueTime'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-issuetime-content = ls_xml_line-value.
        WHEN 'AccountingCustomerParty'.
          CASE ls_xml_line-node_type.
            WHEN 'CO_NT_ELEMENT_OPEN'.
              DATA(lv_from) = lv_index + 1.
              LOOP AT lt_xml_table INTO DATA(ls_xml_line_temp) FROM lv_from.
                CASE ls_xml_line_temp-name.
                  WHEN 'AccountingCustomerParty'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_CLOSE'.
                    EXIT.
                  WHEN 'PartyIdentification'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      APPEND INITIAL LINE TO es_response_structure-senderparty-partyidentification ASSIGNING FIELD-SYMBOL(<ls_identification>).
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
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-senderparty-partyname TO FIELD-SYMBOL(<ls_partyname>).
                    ELSEIF <ls_partyname> IS ASSIGNED.
                      UNASSIGN <ls_partyname>.
                    ENDIF.
                  WHEN 'Country'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-senderparty-postaladdress-country TO FIELD-SYMBOL(<ls_country>).
                    ELSEIF <ls_country> IS ASSIGNED.
                      UNASSIGN <ls_country>.
                    ENDIF.
                  WHEN 'TaxScheme'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-senderparty-partytaxscheme-taxscheme-name TO FIELD-SYMBOL(<ls_taxscheme>).
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
                    es_response_structure-senderparty-postaladdress-citysubdivisionname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'FirstName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-person-firstname-content = ls_xml_line_temp-value.
                  WHEN 'FamilyName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-person-familyname-content = ls_xml_line_temp-value.
                ENDCASE.
              ENDLOOP.
          ENDCASE.
        WHEN 'AccountingSupplierParty'.
          CASE ls_xml_line-node_type.
            WHEN 'CO_NT_ELEMENT_OPEN'.
              lv_from = lv_index + 1.
              LOOP AT lt_xml_table INTO ls_xml_line_temp FROM lv_from.
                CASE ls_xml_line_temp-name.
                  WHEN 'AccountingSupplierParty'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_CLOSE'.
                    EXIT.
                  WHEN 'PartyIdentification'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      APPEND INITIAL LINE TO es_response_structure-receiverparty-partyidentification ASSIGNING <ls_identification>.
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
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-receiverparty-partyname TO <ls_partyname>.
                    ELSEIF <ls_partyname> IS ASSIGNED.
                      UNASSIGN <ls_partyname>.
                    ENDIF.
                  WHEN 'Country'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-receiverparty-postaladdress-country TO <ls_country>.
                    ELSEIF <ls_country> IS ASSIGNED.
                      UNASSIGN <ls_country>.
                    ENDIF.
                  WHEN 'TaxScheme'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-receiverparty-partytaxscheme-taxscheme-name TO <ls_taxscheme>.
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
                    es_response_structure-receiverparty-postaladdress-citysubdivisionname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'FirstName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-person-firstname-content = ls_xml_line_temp-value.
                  WHEN 'FamilyName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-person-familyname-content = ls_xml_line_temp-value.
                ENDCASE.
              ENDLOOP.
          ENDCASE.
      ENDCASE.
    ENDLOOP.

    APPEND INITIAL LINE TO es_response_structure-signature ASSIGNING FIELD-SYMBOL(<ls_signature>).
    <ls_signature>-id-schemeid = 'VKN_TCKN'.
    <ls_signature>-id-content = mv_company_taxid.
    <ls_signature>-signatoryparty = CORRESPONDING #( es_response_structure-senderparty ).
    <ls_signature>-digitalsignatureattachment-externalreference-uri-content = 'Signature_DSB2022000000874'.

    APPEND INITIAL LINE TO es_response_structure-documentresponse ASSIGNING FIELD-SYMBOL(<ls_document_response>).
    APPEND INITIAL LINE TO es_response_structure-note ASSIGNING FIELD-SYMBOL(<ls_note>).
    <ls_note>-content = COND #( WHEN iv_note IS NOT INITIAL THEN iv_note ELSE iv_application_response ).
    APPEND INITIAL LINE TO <ls_document_response>-response-description ASSIGNING <ls_note>.
    <ls_note>-content = COND #( WHEN iv_note IS NOT INITIAL THEN iv_note ELSE iv_application_response ).
    <ls_document_response>-response-responsecode-content = iv_application_response.
    <ls_document_response>-response-referenceid-content = es_response_structure-uuid-content.
    <ls_document_response>-documentreference-issuedate = es_response_structure-issuedate.
    <ls_document_response>-documentreference-id = es_response_structure-uuid.
    <ls_document_response>-documentreference-documenttype-content = 'FATURA'.
    <ls_document_response>-documentreference-documenttypecode-content = 'FATURA'.

    APPEND INITIAL LINE TO <ls_document_response>-lineresponse ASSIGNING FIELD-SYMBOL(<ls_line_response>).
    APPEND INITIAL LINE TO <ls_line_response>-response ASSIGNING FIELD-SYMBOL(<ls_line_response2>).
    <ls_line_response2> = <ls_document_response>-response.
    <ls_line_response>-linereference-lineid-content = ''.

    TRY.
        CALL TRANSFORMATION zetr_ubl21_app_response
          SOURCE root = es_response_structure
          RESULT XML ev_response_xml.
        ev_response_hash = zcl_etr_regulative_common=>calculate_hash_for_raw( ev_response_xml ).
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_error) = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.