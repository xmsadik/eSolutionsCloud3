  METHOD build_delivery_data_common_itm.
    DATA: lv_index          TYPE i,
          ls_delivery_items TYPE mty_item_collect.

    CHECK mt_delivery_items IS NOT INITIAL.

    LOOP AT mt_delivery_items INTO ls_delivery_items.
      lv_index += 1.
      APPEND INITIAL LINE TO ms_delivery_ubl-despatchline ASSIGNING FIELD-SYMBOL(<ls_deilvery_line>).
      <ls_deilvery_line>-id-content = lv_index.

      APPEND INITIAL LINE TO <ls_deilvery_line>-item-additionalitemidentification ASSIGNING FIELD-SYMBOL(<ls_item_identification>).
      <ls_item_identification>-id-schemeid = 'POSNR'.
      <ls_item_identification>-id-content = ls_delivery_items-posnr.

      IF ls_delivery_items-matnr IS NOT INITIAL.
        <ls_deilvery_line>-item-sellersitemidentification-id-content = ls_delivery_items-matnr.
        SHIFT <ls_deilvery_line>-item-sellersitemidentification-id-content LEFT DELETING LEADING '0'.
        CONDENSE <ls_deilvery_line>-item-sellersitemidentification-id-content.
      ENDIF.
      <ls_deilvery_line>-item-buyersitemidentification-id-content = ls_delivery_items-kdmat.
      <ls_deilvery_line>-item-manufacturersitemidentificatio-id-content = ls_delivery_items-admat.
      <ls_deilvery_line>-item-name-content = ls_delivery_items-arktx.
      <ls_deilvery_line>-item-description-content = ls_delivery_items-descr.
      <ls_deilvery_line>-deliveredquantity-content = ls_delivery_items-lfimg.
*      <ls_deilvery_line>-outstandingquantity-content = '0'.
*      APPEND INITIAL LINE TO <ls_deilvery_line>-outstandingreason.
      SELECT SINGLE unitc
        FROM zetr_t_untmc
        WHERE meins = @ls_delivery_items-vrkme
        INTO @<ls_deilvery_line>-deliveredquantity-unitcode.
    ENDLOOP.
  ENDMETHOD.