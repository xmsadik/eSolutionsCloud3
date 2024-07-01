  METHOD outgoing_delivery_save_likp.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE budat,
             defal  TYPE abap_boolean,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_dlprf,
           END OF ty_company,
           BEGIN OF ty_likp,
             vbeln TYPE belnr_d,
             bldat TYPE datum,
             erdat TYPE abp_creation_date,
             erzet TYPE abp_creation_time,
             lfart TYPE zetr_e_lfart,
             kunnr TYPE zetr_e_partner,
             ernam TYPE abp_creation_user,
           END OF ty_likp,
           BEGIN OF ty_lips,
             posnr TYPE n LENGTH 6,
             matnr TYPE matnr,
             kdmat TYPE zetr_e_descr,
             arktx TYPE zetr_e_descr,
             lfimg TYPE menge_d,
             vrkme TYPE meins,
             werks TYPE zetr_e_umwrk,
             lgort TYPE zetr_e_umlgo,
             umwrk TYPE zetr_e_umwrk,
             umlgo TYPE zetr_e_umlgo,
             sobkz TYPE sobkz,
             bwart TYPE bwart,
           END OF ty_lips.
    DATA: lt_lips          TYPE STANDARD TABLE OF ty_lips,
          ls_lips          TYPE ty_lips,
          ls_likp          TYPE ty_likp,
          ls_company_data  TYPE ty_company,
          lt_taxpayer      TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer      TYPE ty_taxpayer,
          ls_document      TYPE zetr_t_ogdlv,
          ls_edrule_input  TYPE zetr_s_delivery_rules_in,
          ls_edrule_output TYPE zetr_s_delivery_rules_out.

    DO 1000 TIMES.
      SELECT SINGLE DeliveryDocument AS vbeln,
                    DeliveryDate AS bldat,
                    CreationDate AS erdat,
                    CreationTime AS erzet,
                    DeliveryDocumentType AS lfart,
                    ShipToParty AS kunnr,
                    CreatedByUser AS ernam
        FROM i_deliverydocument
        WHERE DeliveryDocument = @iv_belnr
        INTO @ls_likp.
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO '0.1' SECONDS.
      ENDIF.
    ENDDO.
    CHECK ls_likp IS NOT INITIAL.

    SELECT SINGLE datab, datbi, genid, prfid
      FROM zetr_t_edpar
      WHERE bukrs = @iv_bukrs
      INTO @ls_company_data.
    CHECK sy-subrc = 0 AND ls_likp-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

    SELECT DeliveryDocumentItem AS posnr,
           Material AS matnr,
           MaterialByCustomer AS kdmat,
           DeliveryDocumentItemText AS arktx,
           ActualDeliveryQuantity AS lfimg,
           DeliveryQuantityUnit AS vrkme,
           Plant AS werks,
           StorageLocation AS lgort,
           IssuingOrReceivingPlant AS umwrk,
           IssuingOrReceivingStorageLoc AS umlgo,
           InventorySpecialStockType AS sobkz,
           GoodsMovementType AS bwart
      FROM I_DeliveryDocumentItem
      WHERE DeliveryDocument = @iv_belnr
      INTO TABLE @lt_lips.
    READ TABLE lt_lips INTO ls_lips INDEX 1.
    CHECK sy-subrc = 0.

    ls_document-werks = ls_lips-werks.
    ls_document-lgort = ls_lips-lgort.
    ls_document-umwrk = ls_lips-umwrk.
    ls_document-umlgo = ls_lips-umlgo.
    ls_document-bwart = ls_lips-bwart.
    ls_document-sobkz = ls_lips-sobkz.
    ls_document-ernam = ls_likp-ernam.
    ls_document-erdat = ls_likp-erdat.
    ls_document-erzet = ls_likp-erzet.
    DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_likp-kunnr ).
    ls_document-taxid = ls_partner_data-bptaxnumber.
    ls_document-partner = ls_partner_data-businesspartner.

    ls_document-bldat = ls_likp-bldat.
    ls_edrule_input-awtyp = iv_awtyp.
    ls_edrule_input-sddty = ls_likp-lfart.
    ls_edrule_input-partner = ls_document-partner.
    ls_edrule_input-werks = ls_lips-werks.
    ls_edrule_input-lgort = ls_lips-lgort.
    ls_edrule_input-umwrk = ls_lips-umwrk.
    ls_edrule_input-umlgo = ls_lips-umlgo.
    ls_edrule_input-sobkz = ls_lips-sobkz.
    ls_edrule_input-bwart = ls_lips-bwart.

    CLEAR ls_edrule_output.
    ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'P'
                                           is_rule_input  = ls_edrule_input ).
    CHECK ls_edrule_output IS NOT INITIAL AND ls_edrule_output-excld IS INITIAL.
    IF ls_edrule_output-pidou IS INITIAL.
      ls_edrule_output-pidou = 'TEMEL'.
    ENDIF.
    IF ls_edrule_output-dtyou IS INITIAL.
      ls_edrule_output-dtyou = 'SEVK'.
    ENDIF.
    ls_document-prfid = ls_edrule_output-pidou.
    ls_document-dlvty = ls_edrule_output-dtyou.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass, regdt, defal
        FROM zetr_t_dlv_ruser
        WHERE taxid = @ls_document-taxid
          AND regdt <= @ls_document-bldat
        INTO TABLE @lt_taxpayer.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-dlvui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-objtype = 'LIKP'.

    ls_edrule_input-dtyin = ls_document-dlvty.
    ls_edrule_input-pidin = ls_document-prfid.
    IF ls_company_data-genid IS NOT INITIAL.
      CLEAR ls_edrule_output.
      ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'S'
                                             is_rule_input  = ls_edrule_input ).
      IF ls_edrule_output IS NOT INITIAL.
        ls_document-serpr = ls_edrule_output-serpr.
      ELSE.
        SELECT SINGLE serpr
          FROM zetr_t_edser
          WHERE bukrs = @iv_bukrs
            AND maisp = @abap_true
          INTO @ls_document-serpr.
      ENDIF.
    ENDIF.

    CLEAR ls_edrule_output.
    ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'X'
                                           is_rule_input  = ls_edrule_input ).
    IF ls_edrule_output IS NOT INITIAL.
      ls_document-xsltt = ls_edrule_output-xsltt.
    ELSE.
      SELECT SINGLE xsltt
        FROM zetr_t_edxslt
        WHERE bukrs = @iv_bukrs
          AND deflt = @abap_true
        INTO @ls_document-xsltt.
    ENDIF.
    es_document = ls_document.

    LOOP AT lt_lips INTO ls_lips.
      CHECK ls_lips-lfimg IS NOT INITIAL.
      APPEND INITIAL LINE TO et_items ASSIGNING FIELD-SYMBOL(<ls_items>).
      <ls_items>-docui = es_document-docui.
      <ls_items>-linno = sy-tabix.
      <ls_items>-selii = ls_lips-matnr.
      <ls_items>-buyii = ls_lips-kdmat.
      <ls_items>-mdesc = ls_lips-arktx.
      <ls_items>-menge = ls_lips-lfimg.
      <ls_items>-meins = ls_lips-vrkme.
    ENDLOOP.
  ENDMETHOD.