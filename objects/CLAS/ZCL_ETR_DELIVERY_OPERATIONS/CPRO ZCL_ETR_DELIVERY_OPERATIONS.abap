  PROTECTED SECTION.
    DATA mv_company_code TYPE bukrs.
    DATA mv_company_taxid TYPE zetr_e_taxid.

    METHODS outgoing_delivery_preview
      IMPORTING
        !iv_document_uid        TYPE sysuuid_c22
        !iv_content_type        TYPE zetr_e_dctyp
        !iv_document_ubl        TYPE xstring
      RETURNING
        VALUE(rv_delivery_data) TYPE zetr_e_dcont
      RAISING
        zcx_etr_regulative_exception .

    METHODS save_incoming_deliveries
      IMPORTING
        !it_list  TYPE mty_incoming_list
        !it_items TYPE mty_incoming_items
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_delivery_save_likp
      IMPORTING
        !iv_awtyp   TYPE zetr_e_awtyp
        !iv_bukrs   TYPE bukrs
        !iv_belnr   TYPE belnr_d
        !iv_gjahr   TYPE gjahr
      EXPORTING
        es_document TYPE mty_outgoing_delivery
        et_items    TYPE mty_outgoing_delivery_items_t
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_delivery_save_mkpf
      IMPORTING
        !iv_awtyp   TYPE zetr_e_awtyp
        !iv_bukrs   TYPE bukrs
        !iv_belnr   TYPE belnr_d
        !iv_gjahr   TYPE gjahr
      EXPORTING
        es_document TYPE mty_outgoing_delivery
        et_items    TYPE mty_outgoing_delivery_items_t
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_delivery_save_bkpf
      IMPORTING
        !iv_awtyp   TYPE zetr_e_awtyp
        !iv_bukrs   TYPE bukrs
        !iv_belnr   TYPE belnr_d
        !iv_gjahr   TYPE gjahr
      EXPORTING
        es_document TYPE mty_outgoing_delivery
        et_items    TYPE mty_outgoing_delivery_items_t
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
        iv_customer    TYPE zetr_e_partner OPTIONAL
        iv_supplier    TYPE zetr_e_partner OPTIONAL
        iv_partner     TYPE zetr_e_partner OPTIONAL
      RETURNING
        VALUE(rs_data) TYPE mty_partner_register_data.
    METHODS get_incoming_item_status_ubl
      IMPORTING
        iv_response_ubl  TYPE zetr_e_dcont
        iv_delivery_ubl  TYPE zetr_e_dcont
      RETURNING
        VALUE(rv_result) TYPE zetr_e_itmrs.
