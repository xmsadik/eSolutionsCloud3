  METHOD build_invoice_data_rmrp_party.
    ms_invoice_ubl-accountingcustomerparty-party = ubl_fill_partner_data( iv_partner = ms_invrec_data-headerdata-diff_inv
                                                                          iv_address_number = ms_invrec_data-address_number
                                                                          iv_tax_id = ms_invrec_data-taxid
                                                                          iv_tax_office = ms_invrec_data-tax_office
                                                                          iv_profile_id = ms_document-prfid ).
  ENDMETHOD.