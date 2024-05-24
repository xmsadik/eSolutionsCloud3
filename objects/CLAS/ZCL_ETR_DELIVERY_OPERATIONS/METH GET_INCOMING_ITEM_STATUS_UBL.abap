  METHOD get_incoming_item_status_ubl.
    TYPES BEGIN OF ty_delivery_lines.
    TYPES id TYPE string.
    TYPES deliveredquantity TYPE menge_d.
    TYPES END OF ty_delivery_lines.

    TYPES BEGIN OF ty_response_lines.
    TYPES id TYPE string.
    TYPES ReceivedQuantity TYPE menge_d.
    TYPES ShortQuantity TYPE menge_d.
    TYPES RejectedQuantity TYPE menge_d.
    TYPES OversupplyQuantity TYPE menge_d.
    TYPES END OF ty_response_lines.

    DATA: lt_delivery_lines TYPE TABLE OF ty_delivery_lines,
          lt_response_lines TYPE TABLE OF ty_response_lines,
          lv_reject         TYPE abap_boolean,
          lv_partial        TYPE abap_boolean.

    DATA(lt_delivery_xml_table) = zcl_etr_regulative_common=>parse_xml( iv_xml_string = ''
                                                                        iv_xml_xstring = iv_delivery_ubl ).
    LOOP AT lt_delivery_xml_table INTO DATA(ls_xml_line) WHERE name = 'DespatchLine'
                                                           AND node_type = 'CO_NT_ELEMENT_OPEN'.
      APPEND INITIAL LINE TO lt_delivery_lines ASSIGNING FIELD-SYMBOL(<ls_delivery_line>).
      DATA(lv_index) = sy-tabix + 1.
      LOOP AT lt_delivery_xml_table INTO DATA(ls_xml_line2) FROM lv_index.
        IF ( ls_xml_line2-name = 'DespatchLine' AND ls_xml_line2-node_type = 'CO_NT_ELEMENT_CLOSE' ).
          EXIT.
        ENDIF.
        CHECK ls_xml_line2-node_type = 'CO_NT_VALUE'.
        CASE ls_xml_line2-name.
          WHEN 'ID'.
            IF <ls_delivery_line>-id IS INITIAL.
              <ls_delivery_line>-id = ls_xml_line2-value.
            ENDIF.
          WHEN 'DeliveredQuantity'.
            <ls_delivery_line>-deliveredquantity = ls_xml_line2-value.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    DATA(lt_response_xml_table) = zcl_etr_regulative_common=>parse_xml( iv_xml_string = ''
                                                                        iv_xml_xstring = iv_delivery_ubl ).
    LOOP AT lt_response_xml_table INTO ls_xml_line WHERE name = 'ReceiptLine'
                                                     AND node_type = 'CO_NT_ELEMENT_OPEN'.
      APPEND INITIAL LINE TO lt_response_lines ASSIGNING FIELD-SYMBOL(<ls_response_line>).
      lv_index = sy-tabix + 1.
      LOOP AT lt_response_xml_table INTO ls_xml_line2 FROM lv_index.
        IF ( ls_xml_line2-name = 'ReceiptLine' AND ls_xml_line2-node_type = 'CO_NT_ELEMENT_CLOSE' ).
          EXIT.
        ENDIF.
        CHECK ls_xml_line2-node_type = 'CO_NT_VALUE'.
        CASE ls_xml_line2-name.
          WHEN 'ID'.
            IF <ls_response_line>-id IS INITIAL.
              <ls_response_line>-id = ls_xml_line2-value.
            ENDIF.
          WHEN 'ReceivedQuantity' OR 'ShortQuantity' OR 'OversupplyQuantity'  OR 'RejectedQuantity'.
            TRANSLATE ls_xml_line2-name TO UPPER CASE.
            ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_response_line> TO FIELD-SYMBOL(<lv_quantity>).
            CHECK sy-subrc = 0.
            <lv_quantity> = ls_xml_line2-value.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    SORT: lt_delivery_lines BY id, lt_response_lines BY id.
    LOOP AT lt_response_lines ASSIGNING <ls_response_line>.
      READ TABLE lt_delivery_lines ASSIGNING <ls_delivery_line>
        WITH KEY id = <ls_response_line>-id
        BINARY SEARCH.
      CHECK sy-subrc = 0.
      IF <ls_response_line>-rejectedquantity IS NOT INITIAL AND
         <ls_response_line>-rejectedquantity <> '0' AND
         <ls_response_line>-rejectedquantity = <ls_delivery_line>-deliveredquantity.
        lv_reject = abap_true.
      ELSEIF <ls_response_line>-rejectedquantity IS NOT INITIAL AND
             <ls_response_line>-rejectedquantity <> '0' AND
             <ls_response_line>-rejectedquantity <> <ls_delivery_line>-deliveredquantity.
        lv_partial = abap_true.
      ELSEIF <ls_response_line>-shortquantity IS NOT INITIAL AND
             <ls_response_line>-shortquantity <> '0' AND
             <ls_response_line>-shortquantity = <ls_delivery_line>-deliveredquantity.
        lv_reject = abap_true.
      ELSEIF <ls_response_line>-shortquantity IS NOT INITIAL AND
             <ls_response_line>-shortquantity <> '0' AND
             <ls_response_line>-shortquantity <> <ls_delivery_line>-deliveredquantity.
        lv_partial = abap_true.
      ENDIF.
    ENDLOOP.
    IF lv_reject = abap_true AND lv_partial = abap_true.
      rv_result = mc_itmres_status_mixed.
    ELSEIF lv_reject = abap_true AND lv_partial = abap_false.
      rv_result = mc_itmres_status_rejected.
    ELSEIF lv_reject = abap_false AND lv_partial = abap_true.
      rv_result = mc_itmres_status_partial.
    ELSE.
      rv_result = mc_itmres_status_approved.
    ENDIF.
  ENDMETHOD.