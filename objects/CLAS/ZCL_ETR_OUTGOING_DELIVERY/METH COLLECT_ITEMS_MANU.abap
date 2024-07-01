  METHOD collect_items_manu.
    DATA: ls_items        TYPE mty_item_collect,
          ls_manual_items TYPE zetr_t_ogdli.

    LOOP AT ms_manual_data-items INTO ls_manual_items.
      CHECK ls_manual_items-menge IS NOT INITIAL.
      CLEAR: ls_items.
      ls_items-arktx = ls_manual_items-mdesc.
      ls_items-descr = ls_manual_items-descr.
      ls_items-matnr = ls_manual_items-selii.
      ls_items-kdmat = ls_manual_items-buyii.
      ls_items-admat = ls_manual_items-manii.
      ls_items-lfimg = ls_manual_items-menge.
      ls_items-vrkme = ls_manual_items-meins.

      IF ms_document-itmcl = abap_false.
        ls_items-posnr = ls_manual_items-linno.
        APPEND ls_items TO mt_delivery_items.
      ELSE.
        CLEAR ls_items-posnr."AS
        COLLECT ls_items INTO mt_delivery_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.