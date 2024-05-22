  METHOD build_delivery_data_likp_party.
    ms_delivery_ubl-deliverycustomerparty-party = ubl_fill_partner_data( iv_address_number = ms_outdel_data-address_number
                                                                         iv_tax_office = ms_outdel_data-tax_office
                                                                         iv_tax_id = ms_outdel_data-taxid
                                                                         iv_profile_id = ms_document-prfid ).
  ENDMETHOD.