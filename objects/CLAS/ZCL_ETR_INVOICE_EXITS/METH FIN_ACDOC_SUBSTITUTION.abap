  METHOD fin_acdoc_substitution.
    TRY.
        zcl_etr_invoice_operations=>factory( iv_company  = is_accountingdocheader-companycode )->accounting_document_save(
          EXPORTING
            is_accountingdocheader   = is_accountingdocheader
            it_accountingdocitems    = it_accountingdocitems
          CHANGING
            cv_substitutiondone      = cv_substitutiondone
            ct_accountingdocitemsout = ct_accountingdocitemsout ).
      CATCH zcx_etr_regulative_exception.
    ENDTRY.
  ENDMETHOD.