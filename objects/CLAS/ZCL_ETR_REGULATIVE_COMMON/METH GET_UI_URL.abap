  METHOD get_ui_url.
    rv_url = xco_cp=>current->tenant( )->get_url( xco_cp_tenant=>url_type->ui )->get_host( ).
  ENDMETHOD.