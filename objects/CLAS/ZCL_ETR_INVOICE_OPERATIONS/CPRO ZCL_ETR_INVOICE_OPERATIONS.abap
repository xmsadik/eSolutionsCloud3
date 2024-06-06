  PROTECTED SECTION.
    DATA mv_company_code TYPE bukrs.

    METHODS outgoing_invoice_preview
      IMPORTING
        !iv_document_uid   TYPE sysuuid_c22
        !iv_content_type   TYPE zetr_e_dctyp
        !iv_document_ubl   TYPE xstring
      RETURNING
        VALUE(rv_document) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_save_vbrk
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE mty_outgoing_invoice
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_invoice_save_rmrp
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE mty_outgoing_invoice
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_invoice_save_bkpf
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE mty_outgoing_invoice
      RAISING
        zcx_etr_regulative_exception.
