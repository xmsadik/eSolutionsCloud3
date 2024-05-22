  METHOD ubl_fill_company_data.
    SELECT SINGLE *
      FROM zetr_t_cmpin
      WHERE bukrs = @iv_bukrs
      INTO @DATA(ls_company).
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e001(zetr_common).
    ENDIF.

    rs_data-websiteuri-content = ls_company-website.
    rs_data-partyname-content = ls_company-title.
    rs_data-partytaxscheme-taxscheme-name-content = ls_company-taxof.
    rs_data-postaladdress-district-content = ls_company-distr.
    rs_data-postaladdress-streetname-content = ls_company-street.
    rs_data-postaladdress-blockname-content = ls_company-blckn.
    rs_data-postaladdress-buildingname-content = ls_company-bldnm.
    rs_data-postaladdress-buildingnumber-content = ls_company-bldno.
    rs_data-postaladdress-room-content = ls_company-roomn.
    rs_data-postaladdress-postbox-content = ls_company-pobox.
    rs_data-postaladdress-postalzone-content = ls_company-pstcd.
    rs_data-postaladdress-citysubdivisionname-content = ls_company-subdv.
    rs_data-postaladdress-cityname-content = ls_company-cityn.
    rs_data-postaladdress-region-content = ls_company-region.
    rs_data-postaladdress-country-content = ls_company-country.
    rs_data-contact-electronicmail-content = ls_company-email.
    rs_data-contact-telephone-content = ls_company-telnm.
    rs_data-contact-telefax-content = ls_company-faxnm.

    SELECT *
      FROM zetr_t_cmppi
      WHERE bukrs = @iv_bukrs
      INTO TABLE @DATA(lt_identifications).
    IF sy-subrc IS INITIAL.
      LOOP AT lt_identifications INTO DATA(ls_identifications).
        APPEND INITIAL LINE TO rs_data-partyidentification ASSIGNING FIELD-SYMBOL(<ls_party_identification>).
        CASE ls_identifications-prtid.                                            .
          WHEN 'VKN'        . <ls_party_identification>-schemeid = 'VKN'                     .
          WHEN 'TCKN'       . <ls_party_identification>-schemeid = 'TCKN'                    .
          WHEN 'HIZMETNO'   . <ls_party_identification>-schemeid = 'HIZMETNO'                .
          WHEN 'MUSTERINO'  . <ls_party_identification>-schemeid = 'MUSTERINO'               .
          WHEN 'TESISATNO'  . <ls_party_identification>-schemeid = 'TESISATNO'               .
          WHEN 'TELEFONNO'  . <ls_party_identification>-schemeid = 'TELEFONNO'               .
          WHEN 'DISTNO'     . <ls_party_identification>-schemeid = 'DISTRIBUTORNO'           .
          WHEN 'TICSICNO'   . <ls_party_identification>-schemeid = 'TICARETSICILNO'          .
          WHEN 'TAPDKNO'    . <ls_party_identification>-schemeid = 'TAPDKNO'                 .
          WHEN 'BAYINO'     . <ls_party_identification>-schemeid = 'BAYINO'                  .
          WHEN 'ABONENO'    . <ls_party_identification>-schemeid = 'ABONENO'                 .
          WHEN 'SAYACNO'    . <ls_party_identification>-schemeid = 'SAYACNO'                 .
          WHEN 'EPDKNO'     . <ls_party_identification>-schemeid = 'EPDKNO'                  .
          WHEN 'SUBENO'     . <ls_party_identification>-schemeid = 'SUBENO'                  .
          WHEN 'PASAPORTNO' . <ls_party_identification>-schemeid = 'PASAPORTNO'              .
          WHEN 'URETICINO'  . <ls_party_identification>-schemeid = 'URETICINO'               .
          WHEN 'CIFTCINO'   . <ls_party_identification>-schemeid = 'CIFTCINO'                .
          WHEN 'IMALATCINO' . <ls_party_identification>-schemeid = 'IMALATCINO'              .
          WHEN 'DOSYANO'    . <ls_party_identification>-schemeid = 'DOSYANO'                 .
          WHEN 'HASTANO'    . <ls_party_identification>-schemeid = 'HASTANO'                 .
          WHEN 'MERSISNO'   . <ls_party_identification>-schemeid = 'MERSISNO'                .
          WHEN 'ARACI_VKN'  . <ls_party_identification>-schemeid = 'ARACIKURUMVKN'           .
          WHEN 'ARACI_ETK'  . <ls_party_identification>-schemeid = 'ARACIKURUMETIKET'        .
          WHEN 'GTB_REFNO'  . <ls_party_identification>-schemeid = 'GTB_REFNO'               .
          WHEN 'GCB_TESCIL' . <ls_party_identification>-schemeid = 'GCB_TESCILNO'            .
          WHEN 'GTB_IHRTAR' . <ls_party_identification>-schemeid = 'GTB_FIILI_IHRACAT_TARIHI'.
          WHEN OTHERS       . <ls_party_identification>-schemeid = ls_identifications-prtid  .
        ENDCASE.
        <ls_party_identification>-content = ls_identifications-value.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.