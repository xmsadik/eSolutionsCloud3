  METHOD build_invoice_data_rmrp_head.
    CONCATENATE ms_invrec_data-headerdata-doc_date+0(4)
                ms_invrec_data-headerdata-doc_date+4(2)
                ms_invrec_data-headerdata-doc_date+6(2)
      INTO ms_invoice_ubl-issuedate-content
      SEPARATED BY '-'.
    ms_invoice_ubl-documentcurrencycode-content = ms_invrec_data-headerdata-currency.

    IF ms_invrec_data-headerdata-currency NE ms_invrec_data-t001-waers.
      ms_invoice_ubl-pricingexchangerate-sourcecurrencycode-content = ms_invrec_data-headerdata-currency.
      ms_invoice_ubl-pricingexchangerate-targetcurrencycode-content = ms_invrec_data-t001-waers.
      ms_invoice_ubl-pricingexchangerate-calculationrate-content = ms_invrec_data-headerdata-exch_rate.
      CONDENSE ms_invoice_ubl-pricingexchangerate-calculationrate-content.
      ms_invoice_ubl-pricingexchangerate-date-content = ms_invoice_ubl-issuedate-content.
      ms_invoice_ubl-pricingcurrencycode-content = ms_invrec_data-headerdata-currency.
    ENDIF.
  ENDMETHOD.