  METHOD build_invoice_data_vbrk_party.
    CASE ms_document-prfid.
      WHEN 'IHRACAT'.
        ms_invoice_ubl-accountingcustomerparty-party = ubl_fill_other_party_data( iv_prtty = 'C' ).
        ms_invoice_ubl-buyercustomerparty-party = ubl_fill_partner_data( iv_partner = ms_billing_data-vbrk-kunre
                                                                         iv_address_number = ms_billing_data-address_number
                                                                         iv_tax_office = ms_billing_data-tax_office
                                                                         iv_tax_id = ms_billing_data-taxid
                                                                         iv_profile_id = ms_document-prfid ).
      WHEN 'YOLCU'.
        ms_invoice_ubl-accountingcustomerparty-party = ubl_fill_other_party_data( iv_prtty = 'C' ).
        ms_invoice_ubl-buyercustomerparty-party = ubl_fill_partner_data( iv_partner = ms_billing_data-vbrk-kunre
                                                                         iv_address_number = ms_billing_data-address_number
                                                                         iv_tax_office = ms_billing_data-tax_office
                                                                         iv_tax_id = ms_billing_data-taxid
                                                                         iv_profile_id = ms_document-prfid ).
      WHEN OTHERS.
        ms_invoice_ubl-accountingcustomerparty-party = ubl_fill_partner_data( iv_partner = ms_billing_data-vbrk-kunre
                                                                              iv_address_number = ms_billing_data-address_number
                                                                              iv_tax_office = ms_billing_data-tax_office
                                                                              iv_tax_id = ms_billing_data-taxid
                                                                              iv_profile_id = ms_document-prfid ).
    ENDCASE.
  ENDMETHOD.