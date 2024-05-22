  PROTECTED SECTION.
    DATA:
      mv_company_taxid      TYPE zetr_e_taxid,
      ms_company_parameters TYPE zetr_t_edpar,
      mt_custom_parameters  TYPE STANDARD TABLE OF zetr_t_edcus
                            WITH NON-UNIQUE SORTED KEY by_cuspa COMPONENTS cuspa,
      mv_request_url        TYPE string.

    METHODS run_service
      IMPORTING
        !iv_request                  TYPE string
        !iv_use_alternative_endpoint TYPE abap_boolean OPTIONAL
        !iv_authenticate             TYPE abap_boolean OPTIONAL
        !it_request_header           TYPE mty_service_header_tab OPTIONAL
      RETURNING
        VALUE(rv_response)           TYPE string
      RAISING
        zcx_etr_regulative_exception.

    METHODS build_application_response
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !is_response_data      TYPE zetr_ddl_i_dlvresp_selection
        !it_response_items     TYPE zcl_etr_delivery_operations=>mty_incoming_items
      EXPORTING
        !ev_response_xml       TYPE xstring
        !ev_response_hash      TYPE mty_hash_code
        !es_response_structure TYPE zif_etr_delivery_ubl21=>receiptadvicetype
      RAISING
        zcx_etr_regulative_exception .
