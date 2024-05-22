  METHOD get_api_url.
    rv_url = xco_cp=>current->tenant( )->get_url( xco_cp_tenant=>url_type->api )->get_host( ).
  ENDMETHOD.