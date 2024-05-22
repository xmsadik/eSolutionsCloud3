  METHOD build_invoice_data_vbrk_totals.
    TYPES BEGIN OF ty_tax_total.
    TYPES tax_code   TYPE string.
    TYPES tax_name   TYPE string.
    TYPES tax_rate   TYPE string.
    TYPES exp_code   TYPE string.
    TYPES exp_name   TYPE string.
    TYPES tax_total  TYPE wrbtr_cs.
    TYPES tax_amount TYPE wrbtr_cs.
    TYPES tax_base   TYPE wrbtr_cs.
    TYPES witholding TYPE abap_boolean.
    TYPES END OF ty_tax_total .
    DATA: lt_tax_total TYPE TABLE OF ty_tax_total,
          ls_tax_total TYPE ty_tax_total.

    LOOP AT ms_invoice_ubl-invoiceline INTO DATA(ls_invoice_line).
      ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content += ls_invoice_line-lineextensionamount-content.
      LOOP AT ls_invoice_line-allowancecharge INTO DATA(ls_allowance_charge).
        IF ls_allowance_charge-chargeindicator-content = abap_false.
          ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-content += ls_allowance_charge-amount-content.
          ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content += ls_allowance_charge-amount-content.
        ELSE.
          ms_invoice_ubl-legalmonetarytotal-chargetotalamount-content += ls_allowance_charge-amount-content.
          ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content -= ls_allowance_charge-amount-content.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    fill_common_tax_totals( ).

    ms_invoice_ubl-legalmonetarytotal-lineextensionamount-currencyid = ms_billing_data-vbrk-waerk.
    ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-content = ms_billing_data-vbrk-netwr.
    ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-currencyid = ms_billing_data-vbrk-waerk.
    ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content = ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content + ms_billing_data-vbrk-netwr.
    ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-currencyid = ms_billing_data-vbrk-waerk.
    IF ms_document-invty NE 'IHRACKAYIT'.
      ms_invoice_ubl-legalmonetarytotal-payableamount-content = ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content.
    ELSE.
      ms_invoice_ubl-legalmonetarytotal-payableamount-content = ms_billing_data-vbrk-netwr.
    ENDIF.
    ms_invoice_ubl-legalmonetarytotal-payableamount-currencyid = ms_billing_data-vbrk-waerk.
    IF ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-content IS NOT INITIAL.
      ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-currencyid = ms_billing_data-vbrk-waerk.
    ENDIF.
    IF ms_invoice_ubl-legalmonetarytotal-chargetotalamount-content IS NOT INITIAL.
      ms_invoice_ubl-legalmonetarytotal-chargetotalamount-currencyid = ms_billing_data-vbrk-waerk.
    ENDIF.
  ENDMETHOD.