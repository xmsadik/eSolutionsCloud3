  METHOD build_invoice_data_bkpf_item.
    collect_items_bkpf( ).
    build_invoice_data_common_item( ms_accdoc_data-t001-kalsm ).
  ENDMETHOD.