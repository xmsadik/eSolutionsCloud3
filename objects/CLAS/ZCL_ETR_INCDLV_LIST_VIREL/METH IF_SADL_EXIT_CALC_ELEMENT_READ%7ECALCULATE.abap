  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_p_incoming_delhead.
    lt_output = CORRESPONDING #( it_original_data ).
    CHECK lt_output IS NOT INITIAL.

    LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
      TRY.
          cl_system_uuid=>convert_uuid_c22_static(
            EXPORTING
              uuid = <ls_output>-documentuuid
            IMPORTING
              uuid_c36 = DATA(lv_uuid) ).
        CATCH cx_uuid_error.
      ENDTRY.

      <ls_output>-PDFContentUrl = 'https://' && zcl_etr_regulative_common=>get_ui_url( ) &&
                                  '/sap/opu/odata/sap/ZETR_DDL_B_INCOMING_DLV/DeliveryContents(DocumentUUID=guid''' &&
                                  lv_uuid && ''',ContentType=''PDF'',DocumentType=''INCDLVDOC'')/$value'.
      IF <ls_output>-ResponseUUID IS NOT INITIAL.
        <ls_output>-ResponseContentUrl = 'https://' && zcl_etr_regulative_common=>get_ui_url( ) &&
                                    '/sap/opu/odata/sap/ZETR_DDL_B_INCOMING_DLV/DeliveryContents(DocumentUUID=guid''' &&
                                    lv_uuid && ''',ContentType=''PDF'',DocumentType=''INCDLVRES'')/$value'.
      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_output ).
  ENDMETHOD.