  METHOD build_invoice_data_bkpf_party.
    DATA: ls_t005t  TYPE mty_t005,
          ls_t005u  TYPE mty_t005u,
          lv_person TYPE abap_bool.
    IF ms_accdoc_data-bsec IS NOT INITIAL.
      ms_invoice_ubl-accountingcustomerparty-party-postaladdress-streetname-content = ms_accdoc_data-bsec-stras .
      ms_invoice_ubl-accountingcustomerparty-party-postaladdress-postalzone-content = ms_accdoc_data-bsec-pstlz.
      IF ms_accdoc_data-bsec-land1 IS NOT INITIAL.
        READ TABLE ms_accdoc_data-t005
          INTO ls_t005t
          WITH TABLE KEY land1 = ms_accdoc_data-bsec-land1.
        IF sy-subrc IS INITIAL.
          ms_invoice_ubl-accountingcustomerparty-party-postaladdress-country-content = ls_t005t-landx.
        ENDIF.
      ENDIF.
      IF ms_accdoc_data-bsec-regio IS NOT INITIAL.
        READ TABLE ms_accdoc_data-t005u
          INTO ls_t005u
          WITH TABLE KEY land1 = ms_accdoc_data-bsec-land1
                         bland = ms_accdoc_data-bsec-regio.
        IF sy-subrc = 0.
          ms_invoice_ubl-accountingcustomerparty-party-postaladdress-cityname-content = ls_t005u-bezei.
        ENDIF.
      ELSEIF ms_accdoc_data-bsec-ort01 IS NOT INITIAL.
        ms_invoice_ubl-accountingcustomerparty-party-postaladdress-cityname-content = ms_accdoc_data-bsec-ort01.
      ENDIF.
      ms_invoice_ubl-accountingcustomerparty-party-postaladdress-citysubdivisionname-content = ms_accdoc_data-bsec-ort01.
      ms_invoice_ubl-accountingcustomerparty-party-partytaxscheme-taxscheme-name-content = ms_accdoc_data-bsec-stcd1.

      IF strlen( ms_accdoc_data-bsec-stcd2 ) = 11 .
        lv_person = abap_true.
        ms_invoice_ubl-accountingcustomerparty-party-person-firstname-content = ms_accdoc_data-bsec-name1.
        ms_invoice_ubl-accountingcustomerparty-party-person-familyname-content = ms_accdoc_data-bsec-name2.
        IF ms_invoice_ubl-accountingcustomerparty-party-person-familyname-content IS INITIAL.
          SPLIT ms_accdoc_data-bsec-name1
            AT space
            INTO ms_invoice_ubl-accountingcustomerparty-party-person-firstname-content
                 ms_invoice_ubl-accountingcustomerparty-party-person-familyname-content.
        ENDIF.
        IF ms_invoice_ubl-accountingcustomerparty-party-person-familyname-content IS INITIAL.
          ms_invoice_ubl-accountingcustomerparty-party-person-firstname-content = ms_accdoc_data-bsec-name1.
          ms_invoice_ubl-accountingcustomerparty-party-person-familyname-content = '...'.
        ENDIF.
        ms_invoice_ubl-accountingcustomerparty-party-person-nationalityid-content = ms_accdoc_data-bsec-land1.
      ELSE.
        CONCATENATE ms_accdoc_data-bsec-name1
                    ms_accdoc_data-bsec-name2
          INTO ms_invoice_ubl-accountingcustomerparty-party-partyname-content
          SEPARATED BY space.
      ENDIF.
      APPEND INITIAL LINE TO ms_invoice_ubl-accountingcustomerparty-party-partyidentification ASSIGNING FIELD-SYMBOL(<ls_identification>).
      IF ms_accdoc_data-bsec-stcd2 IS NOT INITIAL.
        <ls_identification>-content = ms_accdoc_data-bsec-stcd2.
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
    ELSE.
      ms_invoice_ubl-accountingcustomerparty-party = ubl_fill_partner_data( iv_partner = COND #( WHEN ms_accdoc_data-bseg_partner-kunnr IS NOT INITIAL THEN ms_accdoc_data-bseg_partner-kunnr ELSE ms_accdoc_data-bseg_partner-lifnr )
                                                                            iv_address_number = ms_accdoc_data-address_number
                                                                            iv_tax_id = ms_accdoc_data-taxid
                                                                            iv_tax_office = ms_accdoc_data-tax_office
                                                                            iv_profile_id = ms_document-prfid ).
    ENDIF.
  ENDMETHOD.