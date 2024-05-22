  METHOD accounting_document_check.
    CHECK is_accountingdocheader-referencedocumenttype(4) = 'BKPF'.
    SELECT SINGLE *
      FROM zetr_ddl_i_company_information
      WHERE companycode = @is_accountingdocheader-companycode
      INTO @DATA(ls_company_info).
    CHECK sy-subrc = 0.
    READ TABLE it_accountingdocitems
      INTO DATA(ls_accountingdocitem)
      WITH KEY financialaccounttype = 'D'.
    IF sy-subrc <> 0.
      READ TABLE it_accountingdocitems
        INTO ls_accountingdocitem
        WITH KEY financialaccounttype = 'K'.
    ENDIF.
    CHECK ls_accountingdocitem IS NOT INITIAL.
  ENDMETHOD.