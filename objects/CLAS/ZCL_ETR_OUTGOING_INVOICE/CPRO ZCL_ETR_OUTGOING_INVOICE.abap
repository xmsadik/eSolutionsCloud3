  PROTECTED SECTION.
    DATA mo_invoice_operations TYPE REF TO zcl_etr_invoice_operations .
    DATA ms_document TYPE zetr_t_oginv .
    DATA mv_preview TYPE abap_boolean .
    DATA ms_invoice_ubl TYPE zif_etr_invoice_ubl21=>invoicetype .
    DATA mv_invoice_hash TYPE mty_hash_code .
    DATA mv_invoice_ubl TYPE xstring .
    DATA mt_custom_parameters TYPE TABLE OF zetr_t_cmpcp .
    DATA mv_generate_invoice_id TYPE zetr_e_genid .
    DATA mv_company_taxid TYPE zetr_e_taxid .
    DATA mv_add_signature TYPE zetr_e_value .
    DATA mv_barcode TYPE zetr_e_barcode .
    DATA mt_invoice_items TYPE mty_item_collect_t.
    DATA ms_accdoc_data TYPE mty_accdoc_data.
    DATA mt_items_allowance TYPE mty_item_allowance_t .
    DATA ms_invrec_data TYPE mty_invrec_data .
    DATA ms_billing_data TYPE mty_billing_data .
    DATA mv_profile_id TYPE zetr_e_inprf.

    METHODS get_data_vbrk.
    METHODS get_data_bkpf.
    METHODS get_data_rmrp.
    METHODS fill_common_invoice_data
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk_head
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk_ref
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk_party
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk_item
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk_export
      IMPORTING
        !is_vbrp       TYPE mty_vbrp
      RETURNING
        VALUE(rs_data) TYPE mty_export_spec_data .
    METHODS build_invoice_data_vbrk_totals
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_vbrk_notes
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_rmrp
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_rmrp_head
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_rmrp_ref .
    METHODS build_invoice_data_rmrp_party
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_rmrp_item
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_rmrp_totals
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_rmrp_notes
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_bkpf
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_bkpf_head
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_bkpf_party
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_bkpf_item
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_bkpf_totals
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_bkpf_notes
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_common_item
      IMPORTING
        iv_kalsm TYPE mty_kalsm
      RAISING
        zcx_etr_regulative_exception .
    METHODS build_invoice_data_item_change
      IMPORTING
        is_item         TYPE mty_item_collect
      CHANGING
        cs_invoice_line TYPE zif_etr_invoice_ubl21=>invoicelinetype
      RAISING
        zcx_etr_regulative_exception .
    METHODS fill_common_tax_totals
      RAISING
        zcx_etr_regulative_exception .
    METHODS ubl_fill_partner_data
      IMPORTING
        !iv_partner        TYPE zetr_e_partner
        !iv_address_number TYPE ad_addrnum
        !iv_profile_id     TYPE zetr_e_inprf OPTIONAL
        !iv_tax_office     TYPE zetr_e_tax_office OPTIONAL
        !iv_tax_id         TYPE zetr_e_taxid OPTIONAL
      RETURNING
        VALUE(rs_data)     TYPE zif_etr_common_ubl21=>partytype
      RAISING
        zcx_etr_regulative_exception .
    METHODS ubl_fill_company_data
      IMPORTING
        !iv_bukrs      TYPE bukrs
      RETURNING
        VALUE(rs_data) TYPE zif_etr_common_ubl21=>partytype
      RAISING
        zcx_etr_regulative_exception .
    METHODS ubl_fill_other_party_data
      IMPORTING
        !iv_taxid      TYPE zetr_e_taxid OPTIONAL
        !iv_prtty      TYPE zetr_E_PRTTY OPTIONAL
      RETURNING
        VALUE(rs_data) TYPE zif_etr_common_ubl21=>partytype
      RAISING
        zcx_etr_regulative_exception .
    METHODS invoice_abap_to_ubl
      RAISING
        zcx_etr_regulative_exception .
    METHODS get_einvoice_rule
      IMPORTING
        !iv_rule_type         TYPE zetr_E_RULET
        !is_rule_input        TYPE zetr_s_invoice_rules_in
      RETURNING
        VALUE(rt_rule_output) TYPE mty_invoice_rules_out .
    METHODS get_earchive_rule
      IMPORTING
        !iv_rule_type         TYPE zetr_E_RULET
        !is_rule_input        TYPE zetr_s_invoice_rules_in
      RETURNING
        VALUE(rt_rule_output) TYPE mty_invoice_rules_out .
    METHODS collect_items_vbrk .
    METHODS collect_items_vbrk_change_item
      IMPORTING
        is_vbrp TYPE mty_vbrp
      CHANGING
        cs_item TYPE mty_item_collect.
    METHODS collect_items_bkpf .
    METHODS collect_items_rmrp .
