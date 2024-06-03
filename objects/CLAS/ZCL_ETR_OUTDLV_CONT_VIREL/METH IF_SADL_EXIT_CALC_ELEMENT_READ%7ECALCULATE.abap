  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_output TYPE STANDARD TABLE OF zetr_ddl_p_incoming_delcont.
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
            AND docty = @<ls_output>-DocumentType
          INTO @<ls_output>-Content.
        IF <ls_output>-Content IS INITIAL.
          TRY.
              DATA(lo_delivery_operations) = zcl_etr_delivery_operations=>factory( <ls_output>-companycode ).
              CASE <ls_output>-DocumentType.
                WHEN 'OUTDLVRES'.
                  <ls_output>-Content = lo_delivery_operations->outgoing_delivery_respdown( iv_document_uid = <ls_output>-DocumentUUID
                                                                                            iv_content_type = <ls_output>-ContentType ).
                WHEN OTHERS.
                  <ls_output>-Content = lo_delivery_operations->outgoing_delivery_download( iv_document_uid = <ls_output>-DocumentUUID
                                                                                            iv_content_type = <ls_output>-ContentType ).
              ENDCASE.
            CATCH zcx_etr_regulative_exception INTO DATA(lx_etr_regulative_exception).
              <ls_output>-Content = cl_abap_conv_codepage=>create_out( )->convert(
                                                                                   replace( val = '<!DOCTYPE html><html><body><h1>Hata Olustu / Error Occured</h1><p>' &&
                                                                                                   lx_etr_regulative_exception->get_text( ) &&
                                                                                                   '</p></body></html>'
                                                                                            sub = |\n|
                                                                                            with = ``
                                                                                            occ = 0  ) ).
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDIF.
    ct_calculated_data = CORRESPONDING #( lt_output ).
  ENDMETHOD.