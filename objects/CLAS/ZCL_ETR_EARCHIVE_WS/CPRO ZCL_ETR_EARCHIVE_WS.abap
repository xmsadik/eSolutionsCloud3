  PROTECTED SECTION.
    DATA:
      mv_company_taxid      TYPE zetr_e_taxid,
      ms_company_parameters TYPE zetr_t_eapar,
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
