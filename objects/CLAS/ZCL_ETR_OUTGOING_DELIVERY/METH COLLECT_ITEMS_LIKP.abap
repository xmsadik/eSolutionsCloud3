  METHOD collect_items_likp.
    DATA: ls_items TYPE mty_item_collect,
          ls_lips  TYPE mty_lips.

    LOOP AT ms_outdel_data-lips INTO ls_lips.
      CHECK ls_lips-lfimg IS NOT INITIAL.
      CLEAR ls_items.
      ls_items-arktx = ls_lips-arktx.
      ls_items-matnr = ls_lips-matnr.
      ls_items-lfimg = ls_lips-lfimg.
      ls_items-vrkme = ls_lips-vrkme.
      ls_items-kdmat = ls_lips-kdmat.

      IF ms_document-itmcl = abap_false.
        ls_items-posnr = ls_lips-posnr.
        APPEND ls_items TO mt_delivery_items.
      ELSE.
        CLEAR ls_items-posnr."AS
        COLLECT ls_items INTO mt_delivery_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.