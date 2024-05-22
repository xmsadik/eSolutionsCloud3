  METHOD fin_accdoc_validation.
    TRY.
        zcl_etr_invoice_operations=>factory( iv_company  = is_accountingdocheader-companycode )->accounting_document_check(
          EXPORTING
            is_accountingdocheader = is_accountingdocheader
            it_accountingdocitems  = it_accountingdocitems
          CHANGING
            cs_validationmessage   = cs_validationmessage ).
      CATCH zcx_etr_regulative_exception.
    ENDTRY.
  ENDMETHOD.