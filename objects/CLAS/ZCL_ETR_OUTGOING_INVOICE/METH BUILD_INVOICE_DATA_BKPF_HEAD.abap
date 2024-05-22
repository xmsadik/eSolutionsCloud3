  METHOD build_invoice_data_bkpf_head.
    CONCATENATE ms_accdoc_data-bkpf-bldat+0(4)
                ms_accdoc_data-bkpf-bldat+4(2)
                ms_accdoc_data-bkpf-bldat+6(2)
      INTO ms_invoice_ubl-issuedate-content
      SEPARATED BY '-'.
    ms_invoice_ubl-documentcurrencycode-content = ms_accdoc_data-bkpf-waers.

    IF ms_accdoc_data-bkpf-waers NE ms_accdoc_data-bkpf-hwaer.
      ms_invoice_ubl-pricingexchangerate-sourcecurrencycode-content = ms_accdoc_data-bkpf-waers.
      ms_invoice_ubl-pricingexchangerate-targetcurrencycode-content = ms_accdoc_data-bkpf-hwaer.
      ms_invoice_ubl-pricingexchangerate-calculationrate-content = ms_accdoc_data-bkpf-kursf.
      CONDENSE ms_invoice_ubl-pricingexchangerate-calculationrate-content.
      ms_invoice_ubl-pricingexchangerate-date-content = ms_invoice_ubl-issuedate-content.
      ms_invoice_ubl-pricingcurrencycode-content = ms_accdoc_data-bkpf-waers.
    ENDIF.

    IF ms_accdoc_data-bseg_partner-netdt IS NOT INITIAL AND ms_accdoc_data-bseg_partner-netdt NE ms_accdoc_data-bkpf-bldat.
      CONCATENATE ms_accdoc_data-bseg_partner-netdt+0(4)
                  ms_accdoc_data-bseg_partner-netdt+4(2)
                  ms_accdoc_data-bseg_partner-netdt+6(2)
        INTO ms_invoice_ubl-paymentterms-paymentduedate-content
        SEPARATED BY '-'.
    ENDIF.
  ENDMETHOD.