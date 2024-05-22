  METHOD build_invoice_data_rmrp_item.
    collect_items_rmrp( ).
    build_invoice_data_common_item( ms_invrec_data-t001-kalsm ).
  ENDMETHOD.