  PROTECTED SECTION.
    METHODS:
      select_incinv_list
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,
      select_incinv_content
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,
      select_incinv_log
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider.
