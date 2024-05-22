  METHOD build_invoice_data_bkpf_totals.
    DATA: lt_hkont       TYPE RANGE OF hkont,
          lv_base_amount TYPE wrbtr_cs.

    LOOP AT ms_invoice_ubl-invoiceline INTO DATA(ls_invoice_line).
      ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content += ls_invoice_line-lineextensionamount-content.
    ENDLOOP.

    lv_base_amount = ms_invoice_ubl-legalmonetarytotal-lineextensionamount-content.

    LOOP AT ms_accdoc_data-accounts INTO DATA(ls_accounts) USING KEY by_accty WHERE accty = 'D'.
      APPEND VALUE #( sign = 'I'  option = 'EQ' low = ls_accounts-saknr ) TO lt_hkont.
    ENDLOOP.
    IF lt_hkont IS NOT INITIAL.
      LOOP AT ms_accdoc_data-bseg INTO DATA(ls_bseg) USING KEY by_koart WHERE koart = 'S'
                                                                    AND shkzg = 'S'.
        IF ls_bseg-lokkt IS NOT INITIAL .
          CHECK ls_bseg-lokkt IN lt_hkont .
        ELSE.
          CHECK ls_bseg-hkont IN lt_hkont .
        ENDIF.
        IF ls_bseg-wrbtr IS INITIAL AND ls_bseg-dmbtr IS NOT INITIAL.
          ls_bseg-wrbtr = ls_bseg-dmbtr.
        ENDIF.
        ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-content += ls_bseg-wrbtr.
        lv_base_amount -= ls_bseg-wrbtr.
      ENDLOOP.
    ENDIF.

    fill_common_tax_totals( ).

    IF ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-content IS NOT INITIAL.
      ms_invoice_ubl-legalmonetarytotal-allowancetotalamount-currencyid = ms_accdoc_data-bkpf-waers.
    ENDIF.
    ms_invoice_ubl-legalmonetarytotal-lineextensionamount-currencyid = ms_accdoc_data-bkpf-waers.
    ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-content = lv_base_amount.
    ms_invoice_ubl-legalmonetarytotal-taxexclusiveamount-currencyid = ms_accdoc_data-bkpf-waers.
    ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content = ms_accdoc_data-bseg_partner-wrbtr.
    ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-currencyid = ms_accdoc_data-bkpf-waers.
    ms_invoice_ubl-legalmonetarytotal-payableamount-content = ms_accdoc_data-bseg_partner-wrbtr.
    ms_invoice_ubl-legalmonetarytotal-payableamount-currencyid = ms_accdoc_data-bkpf-waers.
  ENDMETHOD.