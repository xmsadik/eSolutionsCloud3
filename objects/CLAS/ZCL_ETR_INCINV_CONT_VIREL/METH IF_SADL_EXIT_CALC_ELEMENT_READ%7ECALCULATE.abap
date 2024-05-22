  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_output TYPE STANDARD TABLE OF zetr_ddl_p_incoming_invcont.
    lt_output = CORRESPONDING #( it_original_data ).
    IF lines( lt_output ) = 1.
      READ TABLE lt_output
        ASSIGNING FIELD-SYMBOL(<ls_output>)
        INDEX 1.
      IF sy-subrc = 0.
        SELECT SINGLE contn
          FROM zetr_t_arcd
          WHERE docui = @<ls_output>-DocumentUUID
            AND conty = @<ls_output>-ContentType
          INTO @<ls_output>-Content.
        IF <ls_output>-Content IS INITIAL.
          TRY.
              DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( <ls_output>-companycode ).
              <ls_output>-Content = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = <ls_output>-DocumentUUID
                                                                                       iv_content_type = <ls_output>-ContentType ).
            CATCH zcx_etr_regulative_exception.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDIF.
    ct_calculated_data = CORRESPONDING #( lt_output ).
  ENDMETHOD.