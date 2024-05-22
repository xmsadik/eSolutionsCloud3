  PROTECTED SECTION.
    METHODS set_incoming_delivery_received
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RAISING
        zcx_etr_regulative_exception .
    METHODS get_incoming_deliveries_int
      IMPORTING
        !iv_date_from      TYPE datum
        !iv_date_to        TYPE datum
      RETURNING
        VALUE(rt_invoices) TYPE mty_incoming_documents
      RAISING
        zcx_etr_regulative_exception.
    METHODS get_incoming_delivery_stat_int
      IMPORTING
        iv_document_uuid TYPE zetr_e_duich
      RETURNING
        VALUE(rs_status) TYPE mty_document_status
      RAISING
        zcx_etr_regulative_exception .