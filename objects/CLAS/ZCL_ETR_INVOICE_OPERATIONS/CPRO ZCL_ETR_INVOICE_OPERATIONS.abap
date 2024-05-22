  PROTECTED SECTION.
    DATA mv_company_code TYPE bukrs.

    METHODS outgoing_invoice_save_vbrk
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_invoice_save_rmrp
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_invoice_save_bkpf
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception.
