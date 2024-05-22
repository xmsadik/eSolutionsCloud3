  METHOD build_delivery_data_common_trn.
    DATA: ls_address TYPE zetr_s_party_info.
    FIELD-SYMBOLS: <ls_transport_handling> TYPE zif_etr_common_ubl21=>transporthandlingunittype.

    APPEND INITIAL LINE TO ms_delivery_ubl-shipment-delivery ASSIGNING FIELD-SYMBOL(<ls_delivery>).
    SELECT SINGLE *
      FROM zetr_t_odth
      WHERE docui = @ms_document-docui
      INTO @DATA(ls_header).

    MOVE-CORRESPONDING ls_header TO ls_address.
    CLEAR: ls_address-title, ls_address-namef, ls_address-namel, ls_address-taxof.
    IF ls_address IS INITIAL.
      IF mv_shipto_address IS NOT INITIAL.
        DATA(ls_partner) = ubl_fill_partner_data( iv_address_number = mv_shipto_address ).
        DATA(ls_postal_address) = ls_partner-postaladdress.
      ELSE.
        ls_postal_address = ms_delivery_ubl-deliverycustomerparty-party-postaladdress.
      ENDIF.
      ls_address-blckn   = ls_postal_address-blockname-content.
      ls_address-bldnm   = ls_postal_address-buildingname-content .
      ls_address-bldno   = ls_postal_address-buildingnumber-content.
      ls_address-cityn   = ls_postal_address-cityname-content.
      ls_address-subdv   = ls_postal_address-citysubdivisionname-content.
      ls_address-country = ls_postal_address-country-content.
      ls_address-distr   = ls_postal_address-district-content.
      ls_address-pobox   = ls_postal_address-postbox-content.
      ls_address-region  = ls_postal_address-region-content.
      ls_address-roomn   = ls_postal_address-room-content.
      ls_address-street  = ls_postal_address-streetname-content.
      ls_address-pstcd   = ls_postal_address-postalzone-content.
    ENDIF.

    IF ls_header-addat IS NOT INITIAL.
      CONCATENATE ls_header-addat+0(4)
                  ls_header-addat+4(2)
                  ls_header-addat+6(2)
        INTO <ls_delivery>-despatch-actualdespatchdate-content
        SEPARATED BY '-'.

      CONCATENATE ls_header-adtim+0(2)
                  ls_header-adtim+2(2)
                  ls_header-adtim+4(2)
                  INTO <ls_delivery>-despatch-actualdespatchtime-content
                  SEPARATED BY ':'.
    ELSE.
      DATA(lv_datlo) = cl_abap_context_info=>get_system_date( ).
      DATA(lv_timlo) = cl_abap_context_info=>get_system_time( ).
      CONCATENATE lv_datlo+0(4)
                  lv_datlo+4(2)
                  lv_datlo+6(2)
        INTO <ls_delivery>-despatch-actualdespatchdate-content
        SEPARATED BY '-'.

      CONCATENATE lv_timlo+0(2)
                  lv_timlo+2(2)
                  lv_timlo+4(2)
                  INTO <ls_delivery>-despatch-actualdespatchtime-content
                  SEPARATED BY ':'.
    ENDIF.

    IF ls_header-taxid IS NOT INITIAL.
      <ls_delivery>-carrierparty-partyname-content = ls_header-title.
      <ls_delivery>-carrierparty-partyname-content = ls_header-title.

      APPEND INITIAL LINE TO <ls_delivery>-carrierparty-partyidentification ASSIGNING FIELD-SYMBOL(<ls_party_identification>).
      IF strlen( ls_header-taxid ) = 11.
        <ls_party_identification>-schemeid = 'TCKN'.
      ELSE.
        <ls_party_identification>-schemeid = 'VKN'.
      ENDIF.
      <ls_party_identification>-content = ls_header-taxid.
    ENDIF.

    SELECT *
      FROM zetr_t_odti
      WHERE docui = @ms_document-docui
      INTO TABLE @DATA(lt_items).
    IF sy-subrc = 0.
      APPEND INITIAL LINE TO ms_delivery_ubl-shipment-shipmentstage ASSIGNING FIELD-SYMBOL(<ls_shipmentg_stage>).
      IF ls_header-vhcll IS NOT INITIAL.
        <ls_shipmentg_stage>-transportmeans-roadtransport-licenseplateid-schemeid = 'PLAKA'.
        <ls_shipmentg_stage>-transportmeans-roadtransport-licenseplateid-content = ls_header-vhcll.
      ENDIF.

      LOOP AT lt_items INTO DATA(ls_item).
        CASE ls_item-trnst.
          WHEN 'D'.
            APPEND INITIAL LINE TO <ls_shipmentg_stage>-driverperson ASSIGNING FIELD-SYMBOL(<ls_driver>).
            <ls_driver>-familyname-content = ls_item-namef.
            <ls_driver>-firstname-content = ls_item-namel.
            <ls_driver>-title-content = ls_item-title.
            <ls_driver>-nationalityid-content = ls_item-trnsp.
          WHEN 'T'.
            IF <ls_transport_handling> IS NOT ASSIGNED.
              APPEND INITIAL LINE TO ms_delivery_ubl-shipment-transporthandlingunit ASSIGNING <ls_transport_handling>.
            ENDIF.
            APPEND INITIAL LINE TO <ls_transport_handling>-transportequipment ASSIGNING FIELD-SYMBOL(<ls_transport_equipment>).
            <ls_transport_equipment>-id-schemeid = 'DORSEPLAKA'.
            <ls_transport_equipment>-id-content = ls_item-trnsp.
        ENDCASE.
      ENDLOOP.
    ENDIF.

    <ls_delivery>-deliveryaddress-blockname-content = ls_address-blckn.
    <ls_delivery>-deliveryaddress-buildingname-content = ls_address-bldnm.
    <ls_delivery>-deliveryaddress-buildingnumber-content = ls_address-bldno.
    <ls_delivery>-deliveryaddress-cityname-content = ls_address-cityn.
    <ls_delivery>-deliveryaddress-citysubdivisionname-content = ls_address-subdv.
    <ls_delivery>-deliveryaddress-country-content = ls_address-country.
    <ls_delivery>-deliveryaddress-district-content = ls_address-distr.
    <ls_delivery>-deliveryaddress-postbox-content = ls_address-pobox.
    <ls_delivery>-deliveryaddress-region-content = ls_address-region.
    <ls_delivery>-deliveryaddress-room-content = ls_address-roomn.
    <ls_delivery>-deliveryaddress-streetname-content = ls_address-street.
    <ls_delivery>-deliveryaddress-postalzone-content = ls_address-pstcd.
  ENDMETHOD.