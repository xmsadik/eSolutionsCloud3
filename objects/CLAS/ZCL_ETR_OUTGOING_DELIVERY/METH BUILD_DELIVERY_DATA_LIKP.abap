  METHOD build_delivery_data_likp.
    get_data_likp( iv_vbeln = ms_document-belnr ).
    build_delivery_data_likp_head( ).
    build_delivery_data_likp_ref( ).
    build_delivery_data_likp_party( ).
    build_delivery_data_likp_trans( ).
    build_delivery_data_likp_item( ).
    build_delivery_data_likp_notes( ).
    fill_common_delivery_data( ).
  ENDMETHOD.