  METHOD accounting_document_check.
    CHECK ( is_accountingdocheader-referencedocumenttype(4) = 'BKPF'
       OR   is_accountingdocheader-referencedocumenttype(4) = 'VBRK'
       OR   is_accountingdocheader-referencedocumenttype(4) = 'RMRP' )
      AND is_accountingdocheader-reversedocument IS NOT INITIAL.
    SELECT SINGLE *
      FROM zetr_ddl_i_company_information
      WHERE companycode = @is_accountingdocheader-companycode
      INTO @DATA(ls_company_info).
    CHECK sy-subrc = 0.

    SELECT SINGLE ReferenceDocumentType, OriginalReferenceDocument
      FROM i_journalentry
      WHERE CompanyCode = @is_accountingdocheader-companycode
        AND AccountingDocument = @is_accountingdocheader-reversedocument
        AND FiscalYear = @is_accountingdocheader-reversedocumentfiscalyear
      INTO @DATA(ls_reversed_document).
    CHECK sy-subrc = 0.

    SELECT SINGLE docui, stacd, prfid, resst, wrbtr, fwste, invii, invno, invui, envui
      FROM zetr_t_oginv
      WHERE bukrs = @is_accountingdocheader-companycode
        AND belnr = @ls_reversed_document-OriginalReferenceDocument(10)
        AND gjahr = @is_accountingdocheader-reversedocumentfiscalyear
      INTO @DATA(ls_edocument).
    CHECK sy-subrc = 0.
    CASE ls_edocument-prfid.
      WHEN 'EARSIV'.
        IF ls_edocument-stacd <> '' AND ls_edocument-stacd <> '2'.
          TRY.
              zcl_etr_earchive_ws=>factory( is_accountingdocheader-companycode )->outgoing_invoice_cancel(
                is_document_numbers     = VALUE #( docui = ls_edocument-docui
                                                   docii = ls_edocument-invii
                                                   docno = ls_edocument-invno
                                                   duich = ls_edocument-invui
                                                   envui = ls_edocument-envui )
                iv_tax_exclusive_amount = CONV #( ls_edocument-wrbtr - ls_edocument-fwste ) ).
            CATCH zcx_etr_regulative_exception INTO DATA(lx_regulative_exception).
              cs_validationmessage-msgid = lx_regulative_exception->if_t100_message~t100key-msgid.
              cs_validationmessage-msgno = lx_regulative_exception->if_t100_message~t100key-msgno.
              cs_validationmessage-msgty = lx_regulative_exception->if_t100_dyn_msg~msgty.
              IF cs_validationmessage-msgty IS INITIAL.
                cs_validationmessage-msgty = 'E'.
              ENDIF.
              cs_validationmessage-msgv1 = lx_regulative_exception->if_t100_dyn_msg~msgv1.
              cs_validationmessage-msgv2 = lx_regulative_exception->if_t100_dyn_msg~msgv2.
              cs_validationmessage-msgv3 = lx_regulative_exception->if_t100_dyn_msg~msgv3.
              cs_validationmessage-msgv4 = lx_regulative_exception->if_t100_dyn_msg~msgv4.
          ENDTRY.
        ENDIF.
        DATA(lv_rev_date) = cl_abap_context_info=>get_system_date( ).
        UPDATE zetr_t_oginv
          SET revch = @abap_true,
              revdt = @lv_rev_date
          WHERE docui = @ls_edocument-docui.
      WHEN OTHERS.
        IF ls_edocument-stacd <> '' AND ls_edocument-stacd <> '2' AND ls_edocument-resst CA 'X02'.
          cs_validationmessage-msgid = 'ZETR_COMMON'.
          cs_validationmessage-msgno = '019'.
          cs_validationmessage-msgty = 'E'.
        ELSE.
          lv_rev_date = cl_abap_context_info=>get_system_date( ).
          UPDATE zetr_t_oginv
            SET revch = @abap_true,
                revdt = @lv_rev_date
            WHERE docui = @ls_edocument-docui.
        ENDIF.
    ENDCASE.

  ENDMETHOD.