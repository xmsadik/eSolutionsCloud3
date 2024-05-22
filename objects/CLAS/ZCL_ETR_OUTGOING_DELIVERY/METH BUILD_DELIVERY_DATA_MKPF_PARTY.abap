  METHOD build_delivery_data_mkpf_party.
    IF ms_goodsmvmt_data-address_number IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e004(zetr_common).
    ENDIF.
    ms_delivery_ubl-deliverycustomerparty-party = ubl_fill_partner_data( iv_address_number = ms_goodsmvmt_data-address_number
                                                                         iv_tax_office = ms_goodsmvmt_data-tax_office
                                                                         iv_tax_id = ms_goodsmvmt_data-taxid
                                                                         iv_profile_id = ms_document-prfid ).
  ENDMETHOD.