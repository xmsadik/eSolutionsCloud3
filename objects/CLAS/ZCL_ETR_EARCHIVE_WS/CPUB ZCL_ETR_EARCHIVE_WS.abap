CLASS zcl_etr_earchive_ws DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      mty_taxpayers_list TYPE STANDARD TABLE OF zetr_t_inv_ruser WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_outgoing_document_status.
    TYPES stacd TYPE zetr_e_stacd.
    TYPES staex TYPE zetr_e_staex.
    TYPES rprid TYPE zetr_e_rprid.
    TYPES envui TYPE zetr_e_envui.
    TYPES invui TYPE zetr_e_duich.
    TYPES invno TYPE zetr_e_docno.
    TYPES END OF mty_outgoing_document_status .
    TYPES:
      BEGIN OF mty_service_header.
    TYPES name TYPE string.
    TYPES value TYPE string.
    TYPES END OF mty_service_header .
    TYPES:
      mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY .

    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_earchive_ws
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_send
      ABSTRACT
      IMPORTING
        !iv_document_uuid     TYPE sysuuid_c22
        !is_ubl_structure     TYPE zif_etr_invoice_ubl21=>invoicetype
        !iv_ubl_xstring       TYPE xstring
        !iv_ubl_hash          TYPE string
        !iv_receiver_alias    TYPE zetr_e_alias
        !iv_receiver_taxid    TYPE zetr_e_taxid
        !iv_earchive_type     TYPE zetr_e_eatyp OPTIONAL
        !iv_internet_sale     TYPE zetr_e_intsl OPTIONAL
        !it_custom_parameters TYPE zcl_etr_outgoing_invoice=>mty_custom_parameters_t OPTIONAL
      EXPORTING
        !ev_integrator_uuid   TYPE zetr_e_docii
        !ev_invoice_uuid      TYPE zetr_e_duich
        !ev_invoice_no        TYPE zetr_e_docno
        !ev_envelope_uuid     TYPE zetr_e_envui
        !es_status            TYPE mty_outgoing_document_status
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_get_status
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_s_document_numbers
      RETURNING
        VALUE(rs_status)     TYPE mty_outgoing_document_status
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE zetr_e_dcont
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_cancel
      ABSTRACT
      IMPORTING
        !is_document_numbers     TYPE zetr_s_document_numbers
        !iv_tax_exclusive_amount TYPE wrbtr_cs OPTIONAL
      RAISING
        zcx_etr_regulative_exception .
