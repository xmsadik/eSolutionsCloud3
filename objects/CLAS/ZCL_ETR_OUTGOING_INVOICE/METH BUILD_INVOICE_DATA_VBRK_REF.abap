  METHOD build_invoice_data_vbrk_ref.
    TYPES BEGIN OF ty_likp.
    TYPES vgbel TYPE belnr_d.
    TYPES vgvsa TYPE c LENGTH 2.
    TYPES vgxbl TYPE c LENGTH 16.
    TYPES vglfx TYPE c LENGTH 35.
    TYPES vgdat TYPE datum.
    TYPES END OF ty_likp.
    DATA lt_likp TYPE STANDARD TABLE OF ty_likp.

    READ TABLE ms_billing_data-vbrp INTO DATA(ls_vbrp) INDEX 1.
    IF sy-subrc IS INITIAL.
      IF ls_vbrp-aubst IS NOT INITIAL.
        ms_invoice_ubl-orderreference-id-content = ls_vbrp-aubst.
      ELSE.
        ms_invoice_ubl-orderreference-id-content = ls_vbrp-aubel.
      ENDIF.
      CONCATENATE ls_vbrp-audat+0(4)
                  ls_vbrp-audat+4(2)
                  ls_vbrp-audat+6(2)
        INTO ms_invoice_ubl-orderreference-issuedate-content
        SEPARATED BY '-'.
    ENDIF.

    lt_likp = CORRESPONDING #( ms_billing_data-vbrp ).
    SORT lt_likp BY vgbel.
    DELETE ADJACENT DUPLICATES FROM lt_likp COMPARING vgbel.
    LOOP AT lt_likp INTO DATA(ls_likp).
      CHECK ls_likp-vgdat IS NOT INITIAL.
      APPEND INITIAL LINE TO ms_invoice_ubl-despatchdocumentreference ASSIGNING FIELD-SYMBOL(<ls_desdoc_ref>).
      IF ls_likp-vgxbl IS NOT INITIAL.
        <ls_desdoc_ref>-id-content = ls_likp-vgxbl.
      ELSEIF ls_likp-vglfx IS NOT INITIAL.
        <ls_desdoc_ref>-id-content = ls_likp-vglfx.
      ELSE.
        <ls_desdoc_ref>-id-content = ls_likp-vgbel.
      ENDIF.
      CONCATENATE ls_likp-vgdat+0(4)
                  ls_likp-vgdat+4(2)
                  ls_likp-vgdat+6(2)
        INTO <ls_desdoc_ref>-issuedate-content
        SEPARATED BY '-'.
    ENDLOOP.
  ENDMETHOD.