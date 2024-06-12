CLASS zcl_etr_einvoice_ws DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      mty_taxpayers_list TYPE STANDARD TABLE OF zetr_t_inv_ruser WITH DEFAULT KEY,
      mty_incoming_list  TYPE STANDARD TABLE OF zetr_t_icinv WITH DEFAULT KEY,
      BEGIN OF mty_outgoing_document_status,
        stacd TYPE zetr_e_stacd,
        staex TYPE zetr_e_staex,
        resst TYPE zetr_e_resst,
        radsc TYPE zetr_e_radsc,
        rsend TYPE zetr_e_rsend,
        raded TYPE zetr_e_raded,
        cedrn TYPE zetr_e_cedrn,
        radrn TYPE zetr_e_radrn,
        envui TYPE zetr_e_envui,
        invui TYPE zetr_e_duich,
        invno TYPE zetr_e_docno,
        invqi TYPE zetr_e_docqi,
        invii TYPE zetr_e_docii,
      END OF mty_outgoing_document_status ,
      BEGIN OF mty_service_header,
        name  TYPE string,
        value TYPE string,
      END OF mty_service_header ,
      mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY,

      BEGIN OF mty_incoming_invoice_status,
        apres TYPE zetr_e_apres,
        resst TYPE zetr_e_resst,
        radsc TYPE zetr_e_radsc,
        staex TYPE zetr_e_staex,
      END     OF mty_incoming_invoice_status.

    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
*      value(IO_INVOICE) type ref to /ITETR/CL_OUTGOING_INVOICE optional
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_einvoice_ws
      RAISING
        zcx_etr_regulative_exception .

    METHODS download_registered_taxpayers
      ABSTRACT
      RETURNING
        VALUE(rt_list) TYPE mty_taxpayers_list
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE zetr_E_dCONT
      RAISING
        zcx_etr_regulative_exception .

    METHODS get_incoming_invoices
      ABSTRACT
      IMPORTING
        !iv_date_from       TYPE datum OPTIONAL
        !iv_date_to         TYPE datum OPTIONAL
        !iv_import_received TYPE zetr_e_imrec OPTIONAL
        !iv_invoice_uuid    TYPE zetr_e_duich OPTIONAL
      EXPORTING
        !ev_message         TYPE bapi_msg
      RETURNING
        VALUE(rt_list)      TYPE mty_incoming_list
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_get_status
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_s_document_numbers
      RETURNING
        VALUE(rs_status)     TYPE mty_incoming_invoice_status
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_response
      ABSTRACT
      IMPORTING
        !is_document_numbers     TYPE zetr_s_document_numbers
        !iv_application_response TYPE zetr_e_apres
        !iv_note                 TYPE zetr_e_notes OPTIONAL
        !iv_receiver_alias       TYPE zetr_e_alias OPTIONAL
        !iv_receiver_taxid       TYPE zetr_e_taxid OPTIONAL
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

    METHODS outgoing_invoice_cancel
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_S_DOCUMENT_NUMBERS
        !iv_document_date    TYPE bldat OPTIONAL
      RAISING
        zcx_etr_regulative_exception .
