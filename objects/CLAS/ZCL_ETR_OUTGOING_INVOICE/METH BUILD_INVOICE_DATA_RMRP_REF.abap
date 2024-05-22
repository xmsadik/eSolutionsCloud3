  METHOD build_invoice_data_rmrp_ref.
    LOOP AT ms_invrec_data-ekbe INTO DATA(ls_ekbe).
      CHECK ls_ekbe-vgabe = '1' AND ls_ekbe-menge IS NOT INITIAL.
*      READ TABLE ms_invrec_data-mseg
*        WITH TABLE KEY mblnr = ls_ekbe-belnr
*                       mjahr = ls_ekbe-gjahr
*                       zeile = ls_ekbe-buzei
*                       TRANSPORTING NO FIELDS.
*      CHECK sy-subrc IS INITIAL.

      APPEND INITIAL LINE TO ms_invoice_ubl-despatchdocumentreference ASSIGNING FIELD-SYMBOL(<ls_desdoc_ref>).
      IF ls_ekbe-xblnr IS NOT INITIAL.
        <ls_desdoc_ref>-id-content = ls_ekbe-xblnr.
      ELSE.
        <ls_desdoc_ref>-id-content = ls_ekbe-belnr.
      ENDIF.
      CONCATENATE ls_ekbe-budat+0(4)
                  ls_ekbe-budat+4(2)
                  ls_ekbe-budat+6(2)
        INTO <ls_desdoc_ref>-issuedate-content
        SEPARATED BY '-'.
    ENDLOOP.

    SORT ms_invoice_ubl-despatchdocumentreference BY id-content.
    DELETE ADJACENT DUPLICATES FROM ms_invoice_ubl-despatchdocumentreference COMPARING id-content.
  ENDMETHOD.