  METHOD build_delivery_data_manu.
    get_data_manu( iv_belnr = ms_document-belnr ).
    build_delivery_data_manu_head( ).
    build_delivery_data_manu_ref( ).
    build_delivery_data_manu_party( ).
    build_delivery_data_manu_item( ).
    build_delivery_data_manu_trans( ).
    build_delivery_data_manu_notes( ).
    fill_common_delivery_data( ).
  ENDMETHOD.