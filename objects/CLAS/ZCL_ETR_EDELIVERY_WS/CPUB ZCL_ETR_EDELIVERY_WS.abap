CLASS zcl_etr_edelivery_ws DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES mty_taxpayers_list TYPE STANDARD TABLE OF zetr_t_dlv_ruser WITH DEFAULT KEY .
    TYPES BEGIN OF mty_service_header.
    TYPES name TYPE string.
    TYPES value TYPE string.
    TYPES END OF mty_service_header .

    TYPES mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY .
    TYPES mty_incoming_deliveries TYPE STANDARD TABLE OF zetr_t_icdlv WITH DEFAULT KEY.
    TYPES mty_incoming_delivery_items TYPE STANDARD TABLE OF zetr_t_icdli WITH DEFAULT KEY.
    TYPES mty_hash_code TYPE c LENGTH 32.

    TYPES BEGIN OF mty_incoming_delivery_status.
    TYPES staex TYPE zetr_e_staex.
    TYPES resst TYPE zetr_e_resst.
    TYPES radsc TYPE zetr_e_radsc.
    TYPES ruuid TYPE zetr_e_ruuid.
    TYPES itmrs TYPE zetr_e_itmrs.
    TYPES END OF mty_incoming_delivery_status.

    TYPES BEGIN OF mty_outgoing_document_status.
    TYPES stacd TYPE zetr_e_stacd.
    TYPES staex TYPE zetr_e_staex.
    TYPES resst TYPE zetr_e_resst.
    TYPES radsc TYPE zetr_e_radsc.
    TYPES rsend TYPE zetr_e_rsend.
    TYPES envui TYPE zetr_e_envui.
    TYPES dlvui TYPE zetr_e_duich.
    TYPES dlvno TYPE zetr_e_docno.
    TYPES dlvqi TYPE zetr_e_docqi.
    TYPES ruuid TYPE zetr_e_ruuid.
    TYPES itmrs TYPE zetr_e_itmrs.
    TYPES END OF mty_outgoing_document_status .

    CONSTANTS mc_erpcode_parameter TYPE zetr_e_cuspa VALUE 'ERPCODE' ##NO_TEXT.
    CONSTANTS mc_itmstat_parameter TYPE zetr_e_cuspa VALUE 'ITRESUBL' ##NO_TEXT.
    CONSTANTS mc_testvkn_parameter TYPE zetr_e_cuspa VALUE 'TESTVKN' ##NO_TEXT.

    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_edelivery_ws
      RAISING
        zcx_etr_regulative_exception .
    METHODS download_registered_taxpayers
      ABSTRACT
      RETURNING
        VALUE(rt_list) TYPE mty_taxpayers_list
      RAISING
        zcx_etr_regulative_exception .
    METHODS get_incoming_deliveries
      ABSTRACT
      IMPORTING
        !iv_date_from TYPE datum OPTIONAL
        !iv_date_to   TYPE datum OPTIONAL
      EXPORTING
        !et_items     TYPE mty_incoming_delivery_items
        !et_list      TYPE mty_incoming_deliveries
      RAISING
        zcx_etr_regulative_exception .
    METHODS incoming_delivery_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .
    METHODS incoming_delivery_get_status
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_s_document_numbers
      RETURNING
        VALUE(rs_status)     TYPE mty_incoming_delivery_status
      RAISING
        zcx_etr_regulative_exception .
    METHODS incoming_delivery_respdown
      ABSTRACT
      IMPORTING
        !is_document_numbers    TYPE zetr_s_document_numbers
        !iv_content_type        TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_response_data) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .
    METHODS incoming_delivery_response
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_s_document_numbers
        !is_response_data    TYPE zetr_ddl_i_dlvresp_selection
        !it_response_items   TYPE zcl_etr_delivery_operations=>mty_incoming_items
      RAISING
        zcx_etr_regulative_exception .
    METHODS outgoing_delivery_send
      ABSTRACT
      IMPORTING
        !iv_document_uuid   TYPE sysuuid_c22
        !is_ubl_structure   TYPE zif_etr_delivery_ubl21=>despatchadvicetype
        !iv_ubl_xstring     TYPE xstring
        !iv_ubl_hash        TYPE string
        !iv_receiver_alias  TYPE zetr_e_alias
        !iv_receiver_taxid  TYPE zetr_e_taxid
*        !it_custom_parameters TYPE zcl_etr_outgoing_delivery=>mty_custom_parameters_t OPTIONAL
      EXPORTING
        !ev_integrator_uuid TYPE zetr_e_docii
        !ev_delivery_uuid   TYPE zetr_e_duich
        !ev_delivery_no     TYPE zetr_e_docno
        !ev_envelope_uuid   TYPE zetr_e_envui
        !es_status          TYPE mty_outgoing_document_status
      RAISING
        zcx_etr_regulative_exception .
    METHODS outgoing_delivery_get_status
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_s_document_numbers
      RETURNING
        VALUE(rs_status)     TYPE mty_outgoing_document_status
      RAISING
        zcx_etr_regulative_exception .
    METHODS outgoing_delivery_download
      ABSTRACT
      IMPORTING
        !is_document_numbers    TYPE zetr_s_document_numbers
        !iv_content_type        TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_delivery_data) TYPE zetr_e_dcont
      RAISING
        zcx_etr_regulative_exception .
    METHODS outgoing_delivery_respdown
      ABSTRACT
      IMPORTING
        !is_document_numbers    TYPE zetr_s_document_numbers
        !iv_content_type        TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_response_data) TYPE zetr_e_dcont
      RAISING
        zcx_etr_regulative_exception .
