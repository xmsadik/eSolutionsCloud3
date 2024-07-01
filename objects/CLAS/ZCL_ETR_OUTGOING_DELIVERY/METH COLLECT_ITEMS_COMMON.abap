  METHOD collect_items_common.
    DATA: ls_items TYPE mty_item_collect,
          ls_item  TYPE zetr_t_ogdli.

    LOOP AT mt_saved_delivery_items INTO ls_item.
      CHECK ls_item-menge IS NOT INITIAL.
      CLEAR ls_items.
      ls_items-arktx = ls_item-mdesc.
      ls_items-descr = ls_item-descr.
      ls_items-matnr = ls_item-selii.
      ls_items-lfimg = ls_item-menge.
      ls_items-vrkme = ls_item-meins.
      ls_items-admat = ls_item-manii.
      ls_items-kdmat = ls_item-buyii.

      IF ms_document-itmcl = abap_false.
        ls_items-posnr = ls_item-linno.
        APPEND ls_items TO mt_delivery_items.
      ELSE.
        CLEAR ls_items-posnr."AS
        COLLECT ls_items INTO mt_delivery_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.