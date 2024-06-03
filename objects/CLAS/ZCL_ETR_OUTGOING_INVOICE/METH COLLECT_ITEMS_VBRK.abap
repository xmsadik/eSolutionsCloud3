  METHOD collect_items_vbrk.
    DATA: ls_items          TYPE mty_item_collect,
          ls_item_allowance TYPE mty_item_allowance.

    LOOP AT ms_billing_data-vbrp INTO DATA(ls_vbrp).
      CHECK ls_vbrp-fkimg IS NOT INITIAL.
      CLEAR ls_items.
      ls_items = CORRESPONDING #( ls_vbrp ).
      ls_items-kdmat = ls_vbrp-aumat.

      READ TABLE ms_billing_data-conditions
        WITH TABLE KEY by_cndty
        COMPONENTS cndty = 'P'
        TRANSPORTING NO FIELDS.
      IF sy-subrc IS INITIAL.
        LOOP AT ms_billing_data-conditions INTO DATA(ls_conditions) USING KEY by_cndty WHERE cndty = 'P'.
          READ TABLE ms_billing_data-konv
            INTO DATA(ls_konv)
            WITH TABLE KEY by_kschl
            COMPONENTS kposn = ls_vbrp-posnr
                       kschl = ls_conditions-kschl
                       kinak = space.
          CHECK sy-subrc IS INITIAL.
          IF ls_konv-konwa = ms_billing_data-vbrk-waerk.
            ls_items-netpr = ls_konv-kbetr.
          ELSE.
            ls_items-netpr = ls_konv-kbetr * ls_konv-kkurs.
          ENDIF.
          ls_items-peinh = ls_konv-kpein.
          ls_items-netwa = ms_billing_data-vbrk-waerk.
          IF ls_konv-kkurs IS NOT INITIAL AND
             ms_billing_data-vbrk-waerk NE ls_konv-konwa AND
             ms_billing_data-vbrk-waerk EQ ms_billing_data-t001-waers.
            ms_billing_data-vbrk-kurrf = ls_konv-kkurs.
          ENDIF.
          EXIT.
        ENDLOOP.
      ENDIF.

      LOOP AT ms_billing_data-konv USING KEY by_koaid INTO ls_konv WHERE kposn = ls_vbrp-posnr
                                                                     AND koaid = 'A'
                                                                     AND kinak = space.
        READ TABLE ms_billing_data-conditions
          WITH TABLE KEY by_kschl
          COMPONENTS kschl = ls_konv-kschl
                     cndty = 'D'
          TRANSPORTING NO FIELDS.
        CHECK sy-subrc EQ 0.
        CLEAR ls_item_allowance.
        ls_item_allowance-posnr = ls_vbrp-posnr.
        IF ls_konv-kwert LT 0.
          ls_konv-kwert = abs( ls_konv-kwert ).
          ls_items-distr += ls_konv-kwert.
          ls_item_allowance-distr = ls_konv-kwert.
        ELSEIF ls_konv-kwert GT 0.
          ls_items-surtr += ls_konv-kwert.
          ls_item_allowance-surtr = ls_konv-kwert.
        ENDIF.
        IF ls_konv-kbetr LT 0 .
          DATA(lv_kbetr) =  CONV wrbtr_cs( abs( ls_konv-kbetr )   / 1000 ).
          ls_items-disrt += lv_kbetr.
          ls_item_allowance-disrt = lv_kbetr.
        ELSEIF ls_konv-kbetr GT 0.
          lv_kbetr =  ls_konv-kbetr   / 1000 .
          ls_items-surrt += lv_kbetr.
          ls_item_allowance-surrt = lv_kbetr.
        ENDIF.
        IF ms_document-itmcl = abap_false.
          APPEND ls_item_allowance TO mt_items_allowance.
        ENDIF.
      ENDLOOP.

      LOOP AT ms_billing_data-conditions INTO ls_conditions USING KEY by_cndty WHERE cndty = 'V'.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_kschl
          COMPONENTS kposn = ls_vbrp-posnr
                     kschl = ls_conditions-kschl
                     kinak = space.
        IF sy-subrc IS INITIAL.
          ls_items-mwskz = ls_konv-mwsk1.
          ls_items-mwsbp = ls_konv-kwert.
        ENDIF.
      ENDLOOP.
      IF ls_items-mwskz IS INITIAL.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_koaid
          COMPONENTS kposn = ls_vbrp-posnr
                     koaid = 'D'
                     kinak = space.
        IF sy-subrc IS INITIAL.
          ls_items-mwskz = ls_konv-mwsk1.
          ls_items-mwsbp = ls_konv-kwert.
        ENDIF.
      ENDIF.

      LOOP AT ms_billing_data-conditions INTO ls_conditions USING KEY by_cndty WHERE cndty = 'O'.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_kschl
          COMPONENTS kposn = ls_vbrp-posnr
                     kschl = ls_conditions-kschl
                     kinak = space.
        CHECK sy-subrc IS INITIAL.
        ls_items-othtx = ls_konv-kwert.
        ls_items-othtt = ls_conditions-taxty.
        DATA(lv_taxrt) = ls_konv-kbetr.
        ls_items-othtr = lv_taxrt.
        EXIT.
      ENDLOOP.

      IF ms_document-prfid = 'IHRACAT'.
        DATA(ls_export_data) = build_invoice_data_vbrk_export( is_vbrp = ls_vbrp ).
        MOVE-CORRESPONDING ls_export_data TO ls_items.
      ENDIF.

      CONDENSE: ls_items-netpr, ls_items-peinh, ls_items-disrt, ls_items-surrt, ls_items-othtr.
      ls_items-waers = ms_billing_data-vbrk-waerk.
      collect_items_vbrk_change_item(
        EXPORTING
          is_vbrp = ls_vbrp
        CHANGING
          cs_item = ls_items ).
      IF ms_document-itmcl = abap_false.
        ls_items-posnr = ls_vbrp-posnr.
        APPEND ls_items TO mt_invoice_items.
      ELSE.
        CLEAR ls_items-posnr.
        COLLECT ls_items INTO mt_invoice_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.