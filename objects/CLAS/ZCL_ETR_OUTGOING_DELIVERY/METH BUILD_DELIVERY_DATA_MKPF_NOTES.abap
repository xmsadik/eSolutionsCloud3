  METHOD build_delivery_data_mkpf_notes.
    LOOP AT ms_goodsmvmt_data-texts INTO DATA(ls_texts).
      LOOP AT ls_texts-tline INTO DATA(ls_tline).
        APPEND INITIAL LINE TO ms_delivery_ubl-note ASSIGNING FIELD-SYMBOL(<ls_delivery_note>).
        <ls_delivery_note>-content = ls_tline-tdline.
      ENDLOOP.
    ENDLOOP.

    READ TABLE ms_outdel_data-lips INTO DATA(ls_lips) INDEX 1.

    DATA(lt_edrule_output) = get_edelivery_rule( iv_rule_type   = 'N'
                                                 is_rule_input  = VALUE #( awtyp = ms_document-awtyp
                                                                           mmdty = ms_goodsmvmt_data-mkpf-blart
                                                                           partner = ms_document-partner
                                                                           werks = ms_document-werks
                                                                           lgort = ms_document-lgort
                                                                           umwrk = ms_document-umwrk
                                                                           umlgo = ms_document-umlgo
                                                                           sobkz = ms_document-sobkz
                                                                           bwart = ms_document-bwart ) ).
    LOOP AT lt_edrule_output INTO DATA(ls_edrule_output).
      APPEND INITIAL LINE TO ms_delivery_ubl-note ASSIGNING <ls_delivery_note>.
      <ls_delivery_note>-content = ls_edrule_output-note.
    ENDLOOP.
  ENDMETHOD.