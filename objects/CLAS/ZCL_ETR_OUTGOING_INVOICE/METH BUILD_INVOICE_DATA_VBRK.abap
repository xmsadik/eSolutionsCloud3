  METHOD build_invoice_data_vbrk.
    get_data_vbrk( ).
    build_invoice_data_vbrk_head( ).
    build_invoice_data_vbrk_ref( ).
    build_invoice_data_vbrk_party( ).
    build_invoice_data_vbrk_item( ).
    build_invoice_data_vbrk_totals( ).
    build_invoice_data_vbrk_notes( ).
    fill_common_invoice_data( ).
  ENDMETHOD.