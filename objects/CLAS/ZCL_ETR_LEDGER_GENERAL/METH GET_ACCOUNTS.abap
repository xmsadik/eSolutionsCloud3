  METHOD get_accounts.
    CLEAR:gr_hkont,gr_hkont[],gt_skb1,gt_skb1[].

    SELECT ssign AS sign,
           soptn AS option,
           splow AS low,
           shigh AS high
      FROM zetr_t_hesbk
     WHERE bukrs = @gv_bukrs
       AND ktopl = @gs_t001-ktopl
       INTO CORRESPONDING FIELDS OF TABLE @gr_hkont.

    SELECT glaccount AS saknr
      FROM I_GLAccountInCompanyCode
     WHERE CompanyCode = @gv_bukrs
     INTO CORRESPONDING FIELDS OF TABLE @gt_skb1.
  ENDMETHOD.