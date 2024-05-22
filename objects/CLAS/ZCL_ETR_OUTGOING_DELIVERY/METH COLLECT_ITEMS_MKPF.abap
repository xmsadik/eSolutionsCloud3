  METHOD collect_items_mkpf.
    DATA: ls_items TYPE mty_item_collect,
          ls_mseg  TYPE mty_mseg,
          ls_ekpo  TYPE mty_ekpo.

    LOOP AT ms_goodsmvmt_data-mseg INTO ls_mseg.
      CHECK ls_mseg-menge IS NOT INITIAL AND ls_mseg-xauto = ''.
      CLEAR: ls_items, ls_ekpo.
      IF ls_mseg-ebeln IS NOT INITIAL.
        READ TABLE ms_goodsmvmt_data-ekpo INTO ls_ekpo WITH KEY ebeln = ls_mseg-ebeln
                                                                ebelp = ls_mseg-ebelp.
        IF sy-subrc = 0.
          ls_items-arktx = ls_ekpo-txz01.
        ENDIF.
      ENDIF.
      IF ls_items-arktx IS INITIAL.
        ls_items-arktx = ls_mseg-maktx.
      ENDIF.
      ls_items-matnr = ls_mseg-matnr.
      ls_items-lfimg = ls_mseg-menge.
      ls_items-vrkme = ls_mseg-meins.

      IF ms_document-itmcl = abap_false.
        ls_items-posnr = ls_mseg-zeile.
        APPEND ls_items TO mt_delivery_items.
      ELSE.
        CLEAR ls_items-posnr."AS
        COLLECT ls_items INTO mt_delivery_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.