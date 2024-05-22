  PROTECTED SECTION.
    DATA mv_company_code TYPE bukrs.
    DATA mv_company_taxid TYPE zetr_e_taxid.

    METHODS save_incoming_deliveries
      IMPORTING
        !it_list  TYPE mty_incoming_list
        !it_items TYPE mty_incoming_items
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_delivery_save_likp
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_ogdlv
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_delivery_save_mkpf
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_ogdlv
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_delivery_save_bkpf
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_ogdlv
      RAISING
        zcx_etr_regulative_exception.

    METHODS get_edelivery_rule
      IMPORTING
        !iv_rule_type         TYPE zetr_E_RULET
        !is_rule_input        TYPE zetr_s_delivery_rules_in
      RETURNING
        VALUE(rs_rule_output) TYPE zetr_s_delivery_rules_out .

    METHODS get_partner_register_data
      IMPORTING
        !iv_customer   TYPE zetr_e_partner OPTIONAL
        !iv_supplier   TYPE zetr_e_partner OPTIONAL
        !iv_partner    TYPE zetr_e_partner OPTIONAL
      RETURNING
        VALUE(rs_data) TYPE mty_partner_register_data.
