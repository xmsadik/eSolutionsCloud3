  METHOD build_invoice_data_vbrk_item.
    collect_items_vbrk( ).
    build_invoice_data_common_item( ms_billing_data-t001-kalsm ).
  ENDMETHOD.