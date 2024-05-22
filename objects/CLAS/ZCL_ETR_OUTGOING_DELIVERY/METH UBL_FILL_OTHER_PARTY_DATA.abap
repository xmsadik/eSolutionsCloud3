  METHOD ubl_fill_other_party_data.
    DATA: lt_taxid TYPE RANGE OF zetr_e_taxid,
          ls_taxid LIKE LINE OF lt_taxid,
          lt_prtty TYPE RANGE OF zetr_e_prtty,
          ls_prtty LIKE LINE OF lt_prtty.
    IF iv_taxid IS NOT INITIAL.
      ls_taxid-sign = 'I'.
      ls_taxid-option = 'EQ'.
      ls_taxid-low = iv_taxid.
      APPEND ls_taxid TO lt_taxid.
    ENDIF.
    IF iv_prtty IS NOT INITIAL.
      ls_prtty-sign = 'I'.
      ls_prtty-option = 'EQ'.
      ls_prtty-low = iv_prtty.
      APPEND ls_prtty TO lt_prtty.
    ENDIF.

    IF iv_taxid IS INITIAL AND iv_prtty IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e025(zetr_common).
    ENDIF.

    SELECT SINGLE *
      FROM zetr_t_othp
      WHERE taxid IN @lt_taxid
        AND prtty IN @lt_prtty
      INTO @DATA(ls_party_data).
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e025(zetr_common).
    ENDIF.

    rs_data-websiteuri-content = ls_party_data-website.
    rs_data-partyname-content = ls_party_data-title.
    rs_data-partytaxscheme-taxscheme-name-content = ls_party_data-taxof.
    rs_data-postaladdress-district-content = ls_party_data-distr.
    rs_data-postaladdress-streetname-content = ls_party_data-street.
    rs_data-postaladdress-blockname-content = ls_party_data-blckn.
    rs_data-postaladdress-buildingname-content = ls_party_data-bldnm.
    rs_data-postaladdress-buildingnumber-content = ls_party_data-bldno.
    rs_data-postaladdress-room-content = ls_party_data-roomn.
    rs_data-postaladdress-postbox-content = ls_party_data-pobox.
    rs_data-postaladdress-postalzone-content = ls_party_data-pstcd.
    rs_data-postaladdress-citysubdivisionname-content = ls_party_data-subdv.
    rs_data-postaladdress-cityname-content = ls_party_data-cityn.
    rs_data-postaladdress-region-content = ls_party_data-region.
    rs_data-postaladdress-country-content = ls_party_data-country.
    rs_data-contact-electronicmail-content = ls_party_data-email.
    rs_data-contact-telephone-content = ls_party_data-telnm.
    rs_data-contact-telefax-content = ls_party_data-faxnm.

    DATA(lv_person) = COND abap_boolean( WHEN strlen( ls_party_data-taxid ) = 11 THEN abap_true ELSE abap_false ).
    APPEND INITIAL LINE TO rs_data-partyidentification ASSIGNING FIELD-SYMBOL(<ls_identification>).
    IF ls_party_data-taxid IS NOT INITIAL.
      <ls_identification>-content = ls_party_data-taxid.
    ELSEIF lv_person = abap_true.
      <ls_identification>-content = '11111111111'.
    ELSE.
      <ls_identification>-content = '1111111111'.
    ENDIF.
    IF strlen( <ls_identification>-content ) = 11.
      <ls_identification>-schemeid = 'TCKN'.
    ELSE.
      <ls_identification>-schemeid = 'VKN'.
    ENDIF.
  ENDMETHOD.