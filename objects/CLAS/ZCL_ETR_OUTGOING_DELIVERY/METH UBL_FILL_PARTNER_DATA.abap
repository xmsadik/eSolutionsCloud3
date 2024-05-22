  METHOD ubl_fill_partner_data.
    SELECT SINGLE *
      FROM i_address_2
      WITH PRIVILEGED ACCESS
      WHERE AddressID = @iv_address_number
      INTO @DATA(ls_address).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e024(zetr_common).
    ENDIF.

    rs_data-postaladdress-streetname-content = ls_address-CareOfName .
    IF ls_address-StreetPrefixName1  IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-StreetPrefixName1
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-StreetPrefixName2 IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-StreetPrefixName2
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-StreetName IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-StreetName
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-StreetSuffixName1 IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-StreetSuffixName1
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-HouseNumber IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-HouseNumber
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-HouseNumberSupplementText IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-HouseNumberSupplementText
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-StreetSuffixName2 IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-StreetSuffixName2
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.
    IF ls_address-DistrictName IS NOT INITIAL.
      CONCATENATE rs_data-postaladdress-streetname-content ls_address-DistrictName
        INTO rs_data-postaladdress-streetname-content
        SEPARATED BY space.
    ENDIF.

    rs_data-postaladdress-postalzone-content = ls_address-PostalCode.
    IF ls_address-country IS NOT INITIAL.
      SELECT SINGLE countryname
        FROM I_CountryText
        WHERE Language = @sy-langu
          AND country = @ls_address-country
        INTO @rs_data-postaladdress-country-content.
    ENDIF.
    IF ls_address-region IS NOT INITIAL.
      SELECT SINGLE regionname
        FROM I_RegionText
        WHERE country = @ls_address-Country
          AND region = @ls_address-Region
        INTO @rs_data-postaladdress-cityname-content.
    ELSEIF ls_address-CityName IS NOT INITIAL.
      rs_data-postaladdress-cityname-content = ls_address-CityName.
    ELSE.
      rs_data-postaladdress-cityname-content = '...'.
    ENDIF.
    IF ls_address-CityName IS NOT INITIAL .
      rs_data-postaladdress-citysubdivisionname-content = ls_address-CityName.
    ELSE.
      rs_data-postaladdress-citysubdivisionname-content = '...'.
    ENDIF.
    rs_data-postaladdress-buildingnumber-content = ls_address-building.
    rs_data-postaladdress-room-content = ls_address-roomnumber.

    SELECT SINGLE *
      FROM I_AddressPhoneNumber_2
      WHERE addressID = @iv_address_number
      INTO @DATA(ls_adtel).

    IF ls_adtel-InternationalPhoneNumber IS NOT INITIAL.
      rs_data-contact-telephone-content = ls_adtel-InternationalPhoneNumber.
    ELSEIF ls_adtel-PhoneAreaCodeSubscriberNumber IS NOT INITIAL.
      rs_data-contact-telephone-content = ls_adtel-PhoneAreaCodeSubscriberNumber.
    ENDIF.

    SELECT SINGLE *
      FROM I_AddressFaxNumber_2
      WHERE addressID = @iv_address_number
      INTO @DATA(ls_adfax).

    IF ls_adfax-InternationalFaxNumber IS NOT INITIAL.
      rs_data-contact-telefax-content = ls_adfax-InternationalFaxNumber.
    ELSEIF ls_adfax-FaxAreaCodeSubscriberNumber IS NOT INITIAL.
      rs_data-contact-telefax-content = ls_adfax-FaxAreaCodeSubscriberNumber.
    ENDIF.

    SELECT SINGLE UniformResourceIdentifier
      FROM I_AddressMainWebsiteURL
      WHERE addressID = @iv_address_number
      INTO @rs_data-websiteuri-content.

    SELECT SINGLE EmailAddress
      FROM I_AddrCurDefaultEmailAddress
      WHERE addressID = @iv_address_number
      INTO @rs_data-contact-electronicmail-content.

    rs_data-partytaxscheme-taxscheme-name-content = iv_tax_office.
    DATA(lv_taxid) = iv_tax_id.

    IF strlen( lv_taxid ) = 11.
      DATA(lv_person) = abap_true.
      rs_data-person-firstname-content = ls_address-PersonGivenName .
      rs_data-person-familyname-content = ls_address-PersonFamilyName.
      IF rs_data-person-familyname-content IS INITIAL.
        SPLIT ls_address-PersonGivenName
          AT space
          INTO rs_data-person-firstname-content
               rs_data-person-familyname-content.
      ENDIF.
      IF rs_data-person-familyname-content IS INITIAL.
        rs_data-person-firstname-content = ls_address-PersonGivenName.
        rs_data-person-familyname-content = '...'.
      ENDIF.
      rs_data-person-nationalityid-content = ls_address-country.
    ELSE.
      CONCATENATE ls_address-OrganizationName1  ls_address-OrganizationName2
                  ls_address-OrganizationName3  ls_address-OrganizationName4
        INTO rs_data-partyname-content
        SEPARATED BY space.
    ENDIF.

    APPEND INITIAL LINE TO rs_data-partyidentification ASSIGNING FIELD-SYMBOL(<ls_identification>).
    IF lv_taxid IS NOT INITIAL.
      <ls_identification>-content = lv_taxid.
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