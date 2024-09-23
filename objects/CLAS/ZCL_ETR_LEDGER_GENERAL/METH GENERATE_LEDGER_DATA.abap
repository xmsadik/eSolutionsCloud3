  METHOD generate_ledger_data.
    init_global_data( i_bukrs ).

    gv_bukrs     = i_bukrs.
    gv_bukrs_tmp = i_bukrs.
    gv_bcode     = i_bcode.
    gv_ledger    = i_ledger.
    gv_tasfiye   = i_tsfyd.
    gr_budat[]   = tr_budat[].
    gr_belnr[]   = tr_belnr[].

    get_company( ).
    get_business_areas( ).
    get_docst_and_ledgrp( ).
    get_accounts( ).
    set_date( ).
    set_blart( ).
    get_f51_params( ).

    IF gt_return[] IS NOT INITIAL.
      te_return[] = gt_return[].
      EXIT.
    ENDIF.

    get_ledger_datas( ).

    te_return[] = gt_return[].
    te_ledger[] = gt_ledger[].
  ENDMETHOD.