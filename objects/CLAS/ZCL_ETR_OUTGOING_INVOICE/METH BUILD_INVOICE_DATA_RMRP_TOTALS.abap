  METHOD build_invoice_data_rmrp_totals.
    DATA lv_amount TYPE wrbtr_cs.
    LOOP AT ms_invoice_ubl-invoiceline INTO DATA(ls_invoice_line).
      ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content += ls_invoice_line-lineextensionamount-content.
    ENDLOOP.

    fill_common_tax_totals( ).

    ms_invoice_ubl-legalmonetarytotal-lineextensionamount-currencyid = ms_invrec_data-headerdata-currency.
    ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-content = ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content.
    ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-currencyid = ms_invrec_data-headerdata-currency.
    lv_amount = ms_invrec_data-headerdata-gross_amnt.
    ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content = lv_amount.
    ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-currencyid = ms_invrec_data-headerdata-currency.
    ms_invoice_ubl-legalmonetarytotal-payableamount-content = lv_amount.
    ms_invoice_ubl-legalmonetarytotal-payableamount-currencyid = ms_invrec_data-headerdata-currency.
  ENDMETHOD.