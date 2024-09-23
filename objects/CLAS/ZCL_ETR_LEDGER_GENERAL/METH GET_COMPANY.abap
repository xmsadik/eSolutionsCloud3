  METHOD get_company.
    CLEAR:gs_bukrs,gs_params,gs_t001,gv_waers,gt_hspplan,gt_hspplan[],gt_skat,gt_skat[]. "gs_bcode

    SELECT SINGLE *
      FROM zetr_t_srkdb
      WHERE bukrs = @gv_bukrs
      INTO @gs_bukrs.

    gv_bukrs_tmp = gv_bukrs.

    IF gs_bukrs-maxcr IS INITIAL.
      "Open Cursor BKPF Select Sayısı
      gs_bukrs-maxcr = 5000.
    ENDIF.

*  IF gv_bcode IS NOT INITIAL.
*    SELECT SINGLE *
*      FROM /itetr/edf_sbblg
*      INTO gs_bcode
*     WHERE bukrs = gv_bukrs
*       AND bcode = gv_bcode.
*
*    IF ( gs_bcode-sub_bukrs IS NOT INITIAL AND
*         gs_bcode-sub_gsber IS INITIAL ) OR
*       gs_bcode-btype EQ 'BUKRS'.
*
*      gv_bukrs     = gs_bcode-sub_bukrs.
*      gv_bukrs_tmp = gs_bcode-bukrs.
*
*      gs_bukrs-adress1     = gs_bcode-adress1.
*      gs_bukrs-adress2     = gs_bcode-adress2.
*      gs_bukrs-house_num   = gs_bcode-house_num.
*      gs_bukrs-postal_code = gs_bcode-postal_code.
*      gs_bukrs-city        = gs_bcode-city.
*      gs_bukrs-country_u   = gs_bcode-country.
*      gs_bukrs-tel_number  = gs_bcode-tel_number.
*      gs_bukrs-fax_number  = gs_bcode-fax_number.
*      gs_bukrs-email       = gs_bcode-email.
*      gs_bukrs-creator     = gs_bcode-creator.
*      gs_bukrs-days45      = gs_bcode-days45.
*    ENDIF.
*  ENDIF.

    IF gs_bukrs-creator IS INITIAL.
      SELECT SINGLE PersonFullName
        FROM I_BusinessUserBasic
       WHERE UserID = @sy-uname
       INTO @gs_bukrs-creator.
    ENDIF.

    SELECT SINGLE *
      FROM zetr_t_dopvr
     WHERE bukrs = @gv_bukrs_tmp
       AND bcode = @gv_bcode
     INTO @gs_params.

    SELECT SINGLE companycode AS bukrs,
                  Currency AS waers,
                  ChartOfAccounts AS ktopl,
                  CountryChartOfAccounts AS ktop2
      FROM I_CompanyCode
     WHERE companycode = @gv_bukrs
     INTO @gs_t001.
    IF gs_t001-ktop2 IS NOT INITIAL.
      gv_alternative = 'X'.
      gs_t001-ktopl  = gs_t001-ktop2.
    ENDIF.

    IF gs_bukrs-ktopl IS NOT INITIAL.
      gs_t001-ktopl  = gs_bukrs-ktopl.
      gv_alternative = space.
    ENDIF.

    IF gs_bukrs-maxit IS INITIAL.
      gs_bukrs-maxit = 20000.
    ENDIF.

*    SELECT *
*      FROM /itetr/edf_symmb
*      INTO TABLE gt_smm
*     WHERE bukrs = gv_bukrs_tmp.

    SELECT SINGLE waers
      FROM zetr_t_dopvr
     WHERE bukrs = @gv_bukrs_tmp
       AND bcode = @gv_bcode
       INTO @gv_waers.
    IF sy-subrc NE 0 OR gv_waers IS INITIAL.
      gv_waers = 'TRY'.
    ENDIF.

    SELECT *
    FROM zetr_t_hespl
*   WHERE bukrs = gv_bukrs_tmp                "YiğitcanÖ. 1307023 Closed.
*     AND ktopl = gs_t001-ktopl.
      WHERE ktopl = @gs_t001-ktopl
      INTO TABLE @gt_hspplan.

    SELECT GLAccount AS saknr, GLAccountLongName AS txt50
      FROM I_GLAccountText
     WHERE ChartOfAccounts = @gs_t001-ktopl
      INTO TABLE @gt_skat.
    IF sy-subrc NE 0 AND gs_bukrs-ktopl IS NOT INITIAL.
      SELECT skat~GLAccount AS saknr, skat~GLAccountLongName AS txt50
        FROM I_GLAccountText AS skat
       INNER JOIN i_companycode AS t001 ON t001~ChartOfAccounts = skat~ChartOfAccounts
       WHERE companycode = @gs_t001-bukrs
       INTO CORRESPONDING FIELDS OF TABLE @gt_skat.
    ENDIF.

*    DELETE gt_skat WHERE spras NE 'T'.

    IF gs_bukrs-ablart IS NOT INITIAL.
      gr_ablart = VALUE #( ( sign = 'I' option = 'EQ' low = gs_bukrs-ablart ) ).
    ENDIF.

    IF gs_bukrs-kblart IS NOT INITIAL.
      gr_kblart = VALUE #( ( sign = 'I' option = 'EQ' low = gs_bukrs-kblart ) ).
    ENDIF.
  ENDMETHOD.