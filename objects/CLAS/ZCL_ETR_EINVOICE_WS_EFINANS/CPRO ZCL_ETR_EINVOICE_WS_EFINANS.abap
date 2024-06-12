  PROTECTED SECTION.
    METHODS get_incoming_invoices_int
      IMPORTING
        !iv_date_from       TYPE datum
        !iv_date_to         TYPE datum
        !iv_import_received TYPE zetr_e_imrec OPTIONAL
        !iv_invoice_uuid    TYPE zetr_e_duich OPTIONAL
      RETURNING
        VALUE(rt_invoices)  TYPE mty_incoming_documents
      RAISING
        zcx_etr_regulative_exception.

    METHODS set_incoming_invoice_received
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RAISING
        zcx_etr_regulative_exception .

    METHODS get_incoming_invoice_stat_int
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RETURNING
        VALUE(rs_status)  TYPE mty_document_status
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_get_fields
      IMPORTING
        it_xml_table TYPE zcl_etr_regulative_common=>mty_xml_nodes
      CHANGING
        cs_invoice   TYPE zetr_t_icinv.
