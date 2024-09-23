  PROTECTED SECTION.

    METHODS :

      select_prep_ledger
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,

      select_prep_ledger_detail
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,

      select_setpart_ledger
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,


      wrt_ledger_to_db
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider.



