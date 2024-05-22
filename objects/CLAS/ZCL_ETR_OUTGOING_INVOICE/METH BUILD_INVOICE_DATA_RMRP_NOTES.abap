  METHOD build_invoice_data_rmrp_notes.
    LOOP AT ms_invrec_data-texts INTO DATA(ls_texts).
      LOOP AT ls_texts-tline INTO DATA(ls_tline).
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING FIELD-SYMBOL(<ls_invoice_note>).
        <ls_invoice_note>-content = ls_tline-tdline.
      ENDLOOP.
    ENDLOOP.
    IF ms_document-prfid NE 'EARSIV'.
      DATA(lt_eirule_output) = get_einvoice_rule( iv_rule_type   = 'N'
                                                  is_rule_input  = VALUE #( awtyp   = ms_document-awtyp
                                                                            vkorg   = ms_document-vkorg
                                                                            vtweg   = ms_document-vtweg
                                                                            werks   = ms_document-werks
                                                                            pidin   = ms_document-prfid
                                                                            ityin   = ms_document-invty
                                                                            sddty   = ''
                                                                            mmdty   = ms_invrec_data-headerdata-doc_type
                                                                            fidty   = ''
                                                                            partner = ms_document-partner
                                                                            vbeln   = '' )  ).
      LOOP AT lt_eirule_output INTO DATA(ls_eirule_output).
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-content = ls_eirule_output-note.
      ENDLOOP.
    ELSE.
      lt_eirule_output = get_earchive_rule( iv_rule_type   = 'N'
                                            is_rule_input  = VALUE #( awtyp   = ms_document-awtyp
                                                                      vkorg   = ms_document-vkorg
                                                                      vtweg   = ms_document-vtweg
                                                                      werks   = ms_document-werks
                                                                      pidin   = ms_document-prfid
                                                                      ityin   = ms_document-invty
                                                                      sddty   = ''
                                                                      mmdty   = ms_invrec_data-headerdata-doc_type
                                                                      fidty   = ''
                                                                      partner = ms_document-partner
                                                                      vbeln   = '' )  ).
      LOOP AT lt_eirule_output INTO ls_eirule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-content = ls_eirule_output-note.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.