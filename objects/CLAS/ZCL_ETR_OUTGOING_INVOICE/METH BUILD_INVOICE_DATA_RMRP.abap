  METHOD build_invoice_data_rmrp.
    get_data_rmrp( ).
    build_invoice_data_rmrp_head( ).
    build_invoice_data_rmrp_ref( ).
    build_invoice_data_rmrp_party( ).
    build_invoice_data_rmrp_item( ).
    build_invoice_data_rmrp_totals( ).
    build_invoice_data_rmrp_notes( ).
    fill_common_invoice_data( ).
  ENDMETHOD.