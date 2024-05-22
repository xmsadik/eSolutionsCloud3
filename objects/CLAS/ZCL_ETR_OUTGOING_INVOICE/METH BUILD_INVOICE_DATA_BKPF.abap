  METHOD build_invoice_data_bkpf.
    get_data_bkpf( ).
    IF ms_accdoc_data-bseg_partner-dmbtr IS NOT INITIAL AND ms_accdoc_data-bseg_partner-wrbtr IS INITIAL.
      ms_accdoc_data-bkpf-waers = ms_accdoc_data-bkpf-hwaer.
      ms_accdoc_data-bseg_partner-wrbtr = ms_accdoc_data-bseg_partner-dmbtr.
    ENDIF.
    build_invoice_data_bkpf_head( ).
    build_invoice_data_bkpf_party( ).
    build_invoice_data_bkpf_item( ).
    build_invoice_data_bkpf_totals( ).
    build_invoice_data_bkpf_notes( ).
    fill_common_invoice_data( ).
  ENDMETHOD.