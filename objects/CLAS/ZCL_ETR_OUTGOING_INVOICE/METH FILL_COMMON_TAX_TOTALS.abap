  METHOD fill_common_tax_totals.
    TYPES BEGIN OF ty_taxtotal.
    TYPES tax_code   TYPE string.
    TYPES tax_name   TYPE string.
    TYPES tax_rate   TYPE string.
    TYPES exp_code   TYPE string.
    TYPES exp_name   TYPE string.
    TYPES taxtotal  TYPE wrbtr_cs.
    TYPES taxamount  TYPE wrbtr_cs.
    TYPES tax_base   TYPE wrbtr_cs.
    TYPES witholding TYPE abap_boolean.
    TYPES END OF ty_taxtotal .
    DATA: lt_taxtotal TYPE TABLE OF ty_taxtotal,
          ls_taxtotal TYPE ty_taxtotal.

    LOOP AT ms_invoice_ubl-invoiceline INTO DATA(ls_invoice_line).
      LOOP AT ls_invoice_line-taxtotal-taxsubtotal INTO DATA(ls_taxsubtotal).
        ls_taxtotal-tax_code  = ls_taxsubtotal-taxcategory-taxscheme-taxtypecode-content.
        ls_taxtotal-tax_name  = ls_taxsubtotal-taxcategory-taxscheme-name-content.
        ls_taxtotal-tax_rate  = ls_taxsubtotal-percent-content.
        ls_taxtotal-exp_code  = ls_taxsubtotal-taxcategory-taxexemptionreasoncode-content.
        ls_taxtotal-exp_name  = ls_taxsubtotal-taxcategory-taxexemptionreason-content.
        ls_taxtotal-taxamount = ls_taxsubtotal-taxamount-content.
        ls_taxtotal-taxtotal = ls_invoice_line-taxtotal-taxamount-content.
        ls_taxtotal-tax_base  = ls_taxsubtotal-taxableamount-content.
        COLLECT ls_taxtotal INTO lt_taxtotal.
        CLEAR ls_taxtotal.
      ENDLOOP.

      LOOP AT ls_invoice_line-withholdingtaxtotal INTO DATA(ls_line_taxtotal).
        LOOP AT ls_line_taxtotal-taxsubtotal INTO ls_taxsubtotal.
          ls_taxtotal-tax_code  = ls_taxsubtotal-taxcategory-taxscheme-taxtypecode-content.
          ls_taxtotal-tax_name  = ls_taxsubtotal-taxcategory-taxscheme-name-content.
          ls_taxtotal-tax_rate  = ls_taxsubtotal-percent-content.
          ls_taxtotal-exp_code  = ls_taxsubtotal-taxcategory-taxexemptionreasoncode-content.
          ls_taxtotal-exp_name  = ls_taxsubtotal-taxcategory-taxexemptionreason-content.
          ls_taxtotal-taxamount = ls_taxsubtotal-taxamount-content.
          ls_taxtotal-taxtotal = ls_line_taxtotal-taxamount-content.
          ls_taxtotal-tax_base  = ls_taxsubtotal-taxableamount-content.
          ls_taxtotal-witholding = 'X'.
          COLLECT ls_taxtotal INTO lt_taxtotal.
          CLEAR ls_taxtotal.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    LOOP AT lt_taxtotal INTO ls_taxtotal.
      IF ls_taxtotal-witholding IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-withholdingtaxtotal ASSIGNING FIELD-SYMBOL(<ls_taxtotal>).
      ELSE.
        APPEND INITIAL LINE TO ms_invoice_ubl-taxtotal ASSIGNING <ls_taxtotal>.
        ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content = ms_invoice_ubl-legalmonetarytotal-taxinclusiveamount-content + ls_taxtotal-taxtotal.
      ENDIF.
      <ls_taxtotal>-taxamount-content = ls_taxtotal-taxtotal.
      <ls_taxtotal>-taxamount-currencyid = ms_invoice_ubl-documentcurrencycode-content.

      APPEND INITIAL LINE TO <ls_taxtotal>-taxsubtotal ASSIGNING FIELD-SYMBOL(<ls_taxsubtotal>).
      <ls_taxsubtotal>-taxcategory-taxscheme-name-content = ls_taxtotal-tax_name.
      <ls_taxsubtotal>-taxcategory-taxscheme-taxtypecode-content = ls_taxtotal-tax_code.
      <ls_taxsubtotal>-taxcategory-taxexemptionreasoncode-content = ls_taxtotal-exp_code.
      <ls_taxsubtotal>-taxcategory-taxexemptionreason-content = ls_taxtotal-exp_name.
      <ls_taxsubtotal>-taxableamount-content = ls_taxtotal-tax_base.
      <ls_taxsubtotal>-taxableamount-currencyid =  ms_invoice_ubl-documentcurrencycode-content.
      <ls_taxsubtotal>-percent-content = ls_taxtotal-tax_rate.
      <ls_taxsubtotal>-taxamount-content = ls_taxtotal-taxamount.
      <ls_taxsubtotal>-taxamount-currencyid =  ms_invoice_ubl-documentcurrencycode-content.
    ENDLOOP.
  ENDMETHOD.