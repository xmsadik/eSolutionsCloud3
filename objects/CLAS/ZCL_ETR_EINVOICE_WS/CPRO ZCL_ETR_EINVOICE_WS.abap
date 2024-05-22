  PROTECTED SECTION.
    DATA:
      mv_company_taxid      TYPE zetr_e_taxid,
      ms_company_parameters TYPE zetr_t_eipar,
      mt_custom_parameters  TYPE STANDARD TABLE OF zetr_t_eicus
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
        !is_document_numbers     TYPE zetr_s_document_numbers
        !iv_application_response TYPE zetr_e_apres
        !iv_note                 TYPE zetr_e_notes OPTIONAL
      EXPORTING
        !ev_response_xml         TYPE xstring
        !ev_response_hash        TYPE string
        !es_response_structure   TYPE zif_etr_app_response_ubl21=>applicationresponsetype
      RAISING
        zcx_etr_regulative_exception.
