  METHOD build_invoice_data_common_item.
    DATA: lv_index  TYPE i,
          lv_amount TYPE wrbtr_cs.
    CHECK mt_invoice_items IS NOT INITIAL.

    LOOP AT mt_invoice_items INTO DATA(ls_invoice_items).
      lv_index += 1.
      APPEND INITIAL LINE TO ms_invoice_ubl-invoiceline ASSIGNING FIELD-SYMBOL(<ls_invoice_line>).
      <ls_invoice_line>-id-content = lv_index.

      APPEND INITIAL LINE TO <ls_invoice_line>-item-additionalitemidentification ASSIGNING FIELD-SYMBOL(<ls_item_identification>).
      <ls_item_identification>-id-schemeid = 'POSNR'.
      <ls_item_identification>-id-content = ls_invoice_items-posnr.

      IF ls_invoice_items-matnr IS NOT INITIAL.
        <ls_invoice_line>-item-sellersitemidentification-id-content = ls_invoice_items-matnr.
        SHIFT <ls_invoice_line>-item-sellersitemidentification-id-content LEFT DELETING LEADING '0'.
        CONDENSE <ls_invoice_line>-item-sellersitemidentification-id-content.
      ENDIF.
      <ls_invoice_line>-item-buyersitemidentification-id-content = ls_invoice_items-kdmat.
      <ls_invoice_line>-item-origincountry-name-content = ls_invoice_items-herkx.
      <ls_invoice_line>-item-manufacturersitemidentificatio-id-content = ls_invoice_items-admat.
      <ls_invoice_line>-item-name-content = ls_invoice_items-arktx.
      <ls_invoice_line>-item-description-content = ls_invoice_items-descr.
      <ls_invoice_line>-item-modelname-content = ls_invoice_items-model.
      <ls_invoice_line>-item-brandname-content = ls_invoice_items-brand.
      <ls_invoice_line>-invoicedquantity-content = ls_invoice_items-fkimg.
      SELECT SINGLE unitc
        FROM zetr_t_untmc
        WHERE meins = @ls_invoice_items-vrkme
        INTO @<ls_invoice_line>-invoicedquantity-unitcode.
      <ls_invoice_line>-lineextensionamount-content = ls_invoice_items-netwr.
      <ls_invoice_line>-lineextensionamount-currencyid = ls_invoice_items-waers.
      CONDENSE ls_invoice_items-netpr.
      IF ls_invoice_items-netpr IS INITIAL OR ls_invoice_items-netpr = '0.00'.
        <ls_invoice_line>-price-priceamount-content = ( ls_invoice_items-netwr + ls_invoice_items-distr - ls_invoice_items-surrt ) / ls_invoice_items-fkimg.
        <ls_invoice_line>-price-priceamount-currencyid = ls_invoice_items-waers.
      ELSE.
        <ls_invoice_line>-price-priceamount-content = ls_invoice_items-netpr / ls_invoice_items-peinh.
        <ls_invoice_line>-price-priceamount-currencyid = ls_invoice_items-netwa.
      ENDIF.

      IF ms_document-prfid = 'IHRACAT'.
        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING FIELD-SYMBOL(<ls_delivery>).
        APPEND INITIAL LINE TO <ls_delivery>-shipment-shipmentstage ASSIGNING FIELD-SYMBOL(<ls_shipment_stage>).
        APPEND INITIAL LINE TO <ls_delivery>-deliveryterms ASSIGNING FIELD-SYMBOL(<ls_delivery_terms>).
        <ls_delivery>-shipment-id-content = ` `.
        DATA(ls_delivery_party) = ubl_fill_partner_data( iv_partner = ls_invoice_items-kunwe
                                                         iv_address_number = ls_invoice_items-adrwe
                                                         iv_profile_id = ms_document-prfid ).
        <ls_delivery>-deliveryaddress = ls_delivery_party-postaladdress.
        <ls_delivery_terms>-id-schemeid = 'INCOTERMS'.
        <ls_delivery_terms>-id-content = ls_invoice_items-inco1.
        <ls_shipment_stage>-transportmodecode-content = ls_invoice_items-trnty.
        <ls_delivery>-shipment-id-content = ` `.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-goodsitem ASSIGNING FIELD-SYMBOL(<ls_goods_item>).
        <ls_goods_item>-requiredcustomsid-content = ls_invoice_items-hscod.

        IF ls_invoice_items-kwrfr IS NOT INITIAL.
          <ls_delivery>-shipment-declaredforcarriagevalueamount-content = ls_invoice_items-kwrfr.
          <ls_delivery>-shipment-declaredforcarriagevalueamount-currencyid = ls_invoice_items-waers.
        ENDIF.
        IF ls_invoice_items-kwrin IS NOT INITIAL.
          <ls_delivery>-shipment-insurancevalueamount-content = ls_invoice_items-kwrin.
          <ls_delivery>-shipment-insurancevalueamount-currencyid = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      IF ls_invoice_items-distr IS NOT INITIAL OR ls_invoice_items-disrt IS NOT INITIAL.
        IF ms_document-itmcl = abap_false.
          LOOP AT mt_items_allowance INTO DATA(ls_item_allowance) WHERE posnr EQ ls_invoice_items-posnr AND ( distr IS NOT INITIAL OR disrt IS NOT INITIAL ).
            APPEND INITIAL LINE TO <ls_invoice_line>-allowancecharge ASSIGNING FIELD-SYMBOL(<ls_allowance_charge>).
            <ls_allowance_charge>-chargeindicator-content = abap_false.
            IF ls_item_allowance-distr IS NOT INITIAL.
              <ls_allowance_charge>-amount-content = ls_item_allowance-distr.
            ENDIF.
            IF ls_item_allowance-disrt IS NOT INITIAL.
              <ls_allowance_charge>-multiplierfactornumeric-content = ls_item_allowance-disrt.
            ENDIF.
            <ls_allowance_charge>-amount-currencyid = ls_invoice_items-waers.
          ENDLOOP.
        ELSE.
          APPEND INITIAL LINE TO <ls_invoice_line>-allowancecharge ASSIGNING <ls_allowance_charge>.
          <ls_allowance_charge>-chargeindicator-content = abap_false.
          IF ls_invoice_items-distr IS NOT INITIAL.
            <ls_allowance_charge>-amount-content = ls_invoice_items-distr.
          ENDIF.
          IF ls_invoice_items-disrt IS NOT INITIAL.
            <ls_allowance_charge>-multiplierfactornumeric-content = ls_invoice_items-disrt.
          ENDIF.
          <ls_allowance_charge>-amount-currencyid = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      IF ls_invoice_items-surtr IS NOT INITIAL OR ls_invoice_items-surrt IS NOT INITIAL.
        IF ms_document-itmcl = abap_false.
          LOOP AT mt_items_allowance INTO ls_item_allowance WHERE posnr EQ ls_invoice_items-posnr AND ( surtr IS NOT INITIAL OR surrt IS NOT INITIAL ).
            APPEND INITIAL LINE TO <ls_invoice_line>-allowancecharge ASSIGNING <ls_allowance_charge>.
            <ls_allowance_charge>-chargeindicator-content = abap_true.
            IF ls_item_allowance-surtr IS NOT INITIAL.
              <ls_allowance_charge>-amount-content = ls_item_allowance-surtr.
            ENDIF.
            IF ls_item_allowance-surrt IS NOT INITIAL.
              <ls_allowance_charge>-multiplierfactornumeric-content = ls_item_allowance-surrt.
            ENDIF.
            <ls_allowance_charge>-amount-currencyid = ls_invoice_items-waers.
          ENDLOOP.
        ELSE.
          APPEND INITIAL LINE TO <ls_invoice_line>-allowancecharge ASSIGNING <ls_allowance_charge>.
          <ls_allowance_charge>-chargeindicator-content = abap_true.
          IF ls_invoice_items-surtr IS NOT INITIAL.
            <ls_allowance_charge>-amount-content = ls_invoice_items-surtr.
          ENDIF.
          IF ls_invoice_items-surrt IS NOT INITIAL.
            <ls_allowance_charge>-multiplierfactornumeric-content = ls_invoice_items-surrt.
          ENDIF.
          <ls_allowance_charge>-amount-currencyid = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      CHECK ls_invoice_items-mwskz IS NOT INITIAL.
      SELECT SINGLE *
        FROM zetr_t_taxmc
        WHERE kalsm = @iv_kalsm
          AND mwskz = @ls_invoice_items-mwskz
        INTO @DATA(ls_tax_match).
      IF ms_document-taxty IS NOT INITIAL.
        ls_tax_match-taxty = ms_document-taxty.
      ENDIF.
      <ls_invoice_line>-taxtotal-taxamount-currencyid = ls_invoice_items-waers.
      SELECT SINGLE *
        FROM zetr_ddl_i_tax_types
        WHERE TaxType = @ls_tax_match-taxty
        INTO @DATA(ls_tax_data).

      IF ls_tax_match-txtyp IS INITIAL.
        IF ls_invoice_items-mwsbp IS INITIAL. "as
          lv_amount = ls_invoice_items-netwr * ls_tax_match-taxrt / 100.
          <ls_invoice_line>-taxtotal-taxamount-content = lv_amount.
        ELSE.
          <ls_invoice_line>-taxtotal-taxamount-content = ls_invoice_items-mwsbp.
        ENDIF.

        APPEND INITIAL LINE TO <ls_invoice_line>-taxtotal-taxsubtotal ASSIGNING FIELD-SYMBOL(<ls_taxsubtotal>).
        <ls_taxsubtotal>-taxcategory-taxscheme-name-content = ls_tax_data-LongDescription.
        <ls_taxsubtotal>-taxcategory-taxscheme-taxtypecode-content = ls_tax_data-TaxType.
        CONDENSE <ls_invoice_line>-taxtotal-taxamount-content.
        IF <ls_invoice_line>-taxtotal-taxamount-content EQ '0.00' OR <ls_invoice_line>-taxtotal-taxamount-content IS INITIAL OR ms_document-invty = 'IHRACKAYIT'.
          IF ms_document-taxex IS NOT INITIAL.
            <ls_taxsubtotal>-taxcategory-taxexemptionreasoncode-content = ms_document-taxex.
            SELECT SINGLE *
              FROM zetr_ddl_i_tax_exemptions
              WHERE ExemptionCode = @ms_document-taxex
              INTO @DATA(ls_tax_exemption).
          ELSE.
            <ls_taxsubtotal>-taxcategory-taxexemptionreasoncode-content = ls_tax_match-taxex.
            SELECT SINGLE *
              FROM zetr_ddl_i_tax_exemptions
              WHERE ExemptionCode = @ls_tax_match-taxex
              INTO @ls_tax_exemption.
          ENDIF.
          <ls_taxsubtotal>-taxcategory-taxexemptionreason-content = ls_tax_exemption-Description.
        ENDIF.
        <ls_taxsubtotal>-taxableamount-content = ls_invoice_items-netwr.
        <ls_taxsubtotal>-taxableamount-currencyid = ls_invoice_items-waers.
        <ls_taxsubtotal>-percent-content = ls_tax_match-taxrt.
        IF ls_invoice_items-mwsbp IS INITIAL. "as
          lv_amount = ls_invoice_items-netwr * ls_tax_match-taxrt / 100.
          <ls_taxsubtotal>-taxamount-content = lv_amount.
        ELSE.
          <ls_taxsubtotal>-taxamount-content = ls_invoice_items-mwsbp.
        ENDIF.
        <ls_taxsubtotal>-taxamount-currencyid = ls_invoice_items-waers.
      ELSE.
        lv_amount = ( ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100 ) * ( 1 - ls_tax_match-taxrt / 100 ).
        <ls_invoice_line>-taxtotal-taxamount-content = lv_amount.
        APPEND INITIAL LINE TO <ls_invoice_line>-taxtotal-taxsubtotal ASSIGNING <ls_taxsubtotal>.
        SELECT SINGLE *
          FROM zetr_ddl_i_tax_types
          WHERE TaxType = @ls_tax_match-txtyp
          INTO @DATA(ls_parent_tax_data).
        <ls_taxsubtotal>-taxcategory-taxscheme-name-content = ls_parent_tax_data-LongDescription.
        <ls_taxsubtotal>-taxcategory-taxscheme-taxtypecode-content = ls_tax_match-txtyp.
        <ls_taxsubtotal>-taxableamount-content = ls_invoice_items-netwr.
        <ls_taxsubtotal>-taxableamount-currencyid = ls_invoice_items-waers.
        <ls_taxsubtotal>-percent-content = ls_tax_match-txrtp.
        lv_amount = ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100.
        <ls_taxsubtotal>-taxamount-content = lv_amount.
        <ls_taxsubtotal>-taxamount-currencyid = ls_invoice_items-waers.
        IF ms_document-invty EQ 'TEVIADE'.
          <ls_taxsubtotal>-taxamount-content = <ls_invoice_line>-taxtotal-taxamount-content.
        ELSE.
          IF ls_tax_data-TaxCategory = 'TEV'.
            APPEND INITIAL LINE TO <ls_invoice_line>-withholdingtaxtotal ASSIGNING FIELD-SYMBOL(<ls_taxtotal>).
            lv_amount = ( ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
            <ls_taxtotal>-taxamount-content = lv_amount.
            <ls_taxtotal>-taxamount-currencyid = ls_invoice_items-waers.
            APPEND INITIAL LINE TO <ls_taxtotal>-taxsubtotal ASSIGNING <ls_taxsubtotal>.
          ELSE.
            APPEND INITIAL LINE TO <ls_invoice_line>-withholdingtaxtotal ASSIGNING <ls_taxtotal>.
            APPEND INITIAL LINE TO <ls_taxtotal>-taxsubtotal ASSIGNING <ls_taxsubtotal>.
          ENDIF.
          IF ms_document-taxty IS NOT INITIAL.
            <ls_taxsubtotal>-taxcategory-taxscheme-taxtypecode-content = ms_document-taxty.
            SELECT SINGLE *
              FROM zetr_ddl_i_tax_types
              WHERE TaxType = @ms_document-taxty
              INTO @ls_tax_data.
            <ls_taxsubtotal>-taxcategory-taxscheme-name-content = ls_tax_data-LongDescription.
          ELSE.
            <ls_taxsubtotal>-taxcategory-taxscheme-taxtypecode-content = ls_tax_match-taxty.
            <ls_taxsubtotal>-taxcategory-taxscheme-name-content = ls_tax_data-LongDescription.
          ENDIF.
          lv_amount = ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100.
          <ls_taxsubtotal>-taxableamount-content = lv_amount.
          <ls_taxsubtotal>-taxableamount-currencyid = ls_invoice_items-waers.
          <ls_taxsubtotal>-percent-content = ls_tax_match-taxrt.
          lv_amount = ( ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
          <ls_taxsubtotal>-taxamount-content = lv_amount.
          <ls_taxsubtotal>-taxamount-currencyid = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      IF ls_invoice_items-othtx IS NOT INITIAL.
        SELECT SINGLE *
          FROM zetr_ddl_i_tax_types
          WHERE TaxType = @ls_invoice_items-othtt
          INTO @ls_tax_data.
        APPEND INITIAL LINE TO <ls_invoice_line>-taxtotal-taxsubtotal ASSIGNING <ls_taxsubtotal>.
        <ls_taxsubtotal>-taxcategory-taxscheme-name-content = ls_tax_data-LongDescription.
        <ls_taxsubtotal>-taxcategory-taxscheme-taxtypecode-content = ls_invoice_items-othtt.
        <ls_taxsubtotal>-taxableamount-content = ls_invoice_items-netwr.
        <ls_taxsubtotal>-taxableamount-currencyid = ls_invoice_items-waers.
        <ls_taxsubtotal>-percent-content = ls_invoice_items-othtr.
        <ls_taxsubtotal>-taxamount-content = ls_invoice_items-othtx.
        <ls_taxsubtotal>-taxamount-currencyid = ls_invoice_items-waers.
      ENDIF.

      build_invoice_data_item_change(
        EXPORTING
          is_item         = ls_invoice_items
        CHANGING
          cs_invoice_line = <ls_invoice_line> ).
    ENDLOOP.
  ENDMETHOD.