  METHOD collect_items_bkpf.
    DATA: lt_hkont TYPE RANGE OF hkont,
          ls_hkont LIKE LINE OF lt_hkont,
          ls_items TYPE mty_item_collect.

    LOOP AT ms_accdoc_data-accounts INTO DATA(ls_accounts).
      ls_hkont-sign = 'I'.
      ls_hkont-option = 'EQ'.
      ls_hkont-low = ls_accounts-saknr.
      APPEND ls_hkont TO lt_hkont.
    ENDLOOP.

    LOOP AT ms_accdoc_data-bseg INTO DATA(ls_bseg_lines)  WHERE ( koart = 'S' OR
                                                                  koart = 'A' )
                                                            AND shkzg = 'H' .
      IF ls_bseg_lines-lokkt IS NOT INITIAL.
        ls_bseg_lines-hkont = ls_bseg_lines-lokkt.
      ENDIF.
      CHECK ls_bseg_lines-hkont NOT IN lt_hkont.
      IF ls_bseg_lines-wrbtr IS INITIAL AND ls_bseg_lines-dmbtr IS NOT INITIAL.
        ls_bseg_lines-wrbtr = ls_bseg_lines-dmbtr.
      ENDIF.

      READ TABLE ms_accdoc_data-accounts
        WITH TABLE KEY saknr = ls_bseg_lines-hkont
        TRANSPORTING NO FIELDS.
      CHECK sy-subrc IS NOT INITIAL.

      CLEAR ls_items.
      ls_items-posnr = ls_bseg_lines-buzei.
      ls_items-matnr = ls_bseg_lines-matnr.
      ls_items-kdmat = ls_bseg_lines-hkont.

      IF ls_bseg_lines-sgtxt IS NOT INITIAL.
        ls_items-arktx = ls_bseg_lines-sgtxt.
      ELSEIF ms_accdoc_data-bseg_partner-sgtxt IS NOT INITIAL.
        ls_items-arktx = ms_accdoc_data-bseg_partner-sgtxt.
      ELSE.
        ls_items-arktx = ls_bseg_lines-txt50.
      ENDIF.
*      IF ls_bseg_lines-menge IS NOT INITIAL.
*        ls_items-fkimg = ls_bseg_lines-menge.
*      ELSE.
      ls_items-fkimg = 1.
*      ENDIF.
*      IF ls_bseg_lines-meins IS NOT INITIAL.
*        ls_items-vrkme = ls_bseg_lines-meins.
*      ELSE.
      ls_items-vrkme = 'ST'.
*      ENDIF.
      ls_items-netwr = ls_bseg_lines-wrbtr.
      ls_items-mwskz = ls_bseg_lines-mwskz.
      ls_items-waers = ms_accdoc_data-bkpf-waers.
      IF ms_document-itmcl IS NOT INITIAL.
        CLEAR ls_items-posnr.
        COLLECT ls_items INTO mt_invoice_items.
      ELSE.
        APPEND ls_items TO mt_invoice_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.