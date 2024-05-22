  METHOD build_invoice_data_vbrk_head.
    CONCATENATE ms_billing_data-vbrk-fkdat+0(4)
                ms_billing_data-vbrk-fkdat+4(2)
                ms_billing_data-vbrk-fkdat+6(2)
      INTO ms_invoice_ubl-issuedate-content
      SEPARATED BY '-'.
    IF ms_billing_data-vbrk-netdt IS NOT INITIAL.
      CONCATENATE ms_billing_data-vbrk-netdt+0(4)
                  ms_billing_data-vbrk-netdt+4(2)
                  ms_billing_data-vbrk-netdt+6(2)
        INTO ms_invoice_ubl-paymentterms-paymentduedate-content
        SEPARATED BY '-'.
    ENDIF.
    ms_invoice_ubl-documentcurrencycode-content = ms_billing_data-vbrk-waerk.
    IF ms_billing_data-vbrk-waerk NE ms_billing_data-t001-waers.
      ms_invoice_ubl-pricingexchangerate-sourcecurrencycode-content = ms_billing_data-vbrk-waerk.
      ms_invoice_ubl-pricingexchangerate-targetcurrencycode-content = ms_billing_data-t001-waers.
      ms_invoice_ubl-pricingexchangerate-calculationrate-content = ms_billing_data-vbrk-kurrf.
      CONDENSE ms_invoice_ubl-pricingexchangerate-calculationrate-content.
      CONCATENATE ms_billing_data-vbrk-kurrf_dat+0(4)
                  ms_billing_data-vbrk-kurrf_dat+4(2)
                  ms_billing_data-vbrk-kurrf_dat+6(2)
        INTO ms_invoice_ubl-pricingexchangerate-date-content
        SEPARATED BY '-'.
      ms_invoice_ubl-pricingcurrencycode-content = ms_billing_data-vbrk-waerk.
    ENDIF.
  ENDMETHOD.