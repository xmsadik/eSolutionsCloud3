  METHOD build_delivery_data_mkpf.
    get_data_mkpf( iv_mblnr = ms_document-belnr
                   iv_mjahr = ms_document-gjahr ).
    build_delivery_data_mkpf_head( ).
    build_delivery_data_mkpf_ref( ).
    build_delivery_data_mkpf_party( ).
    build_delivery_data_mkpf_item( ).
    build_delivery_data_mkpf_trans( ).
    build_delivery_data_mkpf_notes( ).
    fill_common_delivery_data( ).
  ENDMETHOD.