  METHOD build_delivery_data_manu_party.
    ms_delivery_ubl-deliverycustomerparty-party = ubl_fill_partner_data( iv_address_number = ms_manual_data-address_number
                                                                         iv_tax_office = ms_manual_data-tax_office
                                                                         iv_tax_id = ms_manual_data-taxid
                                                                         iv_profile_id = ms_document-prfid ).
  ENDMETHOD.