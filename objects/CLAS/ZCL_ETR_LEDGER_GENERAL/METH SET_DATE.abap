  METHOD set_date.
    DATA: lv_first_day    TYPE datum,
          lv_tastar_check TYPE datum.

    READ TABLE gr_budat ASSIGNING FIELD-SYMBOL(<ls_budat>) INDEX 1.

    IF <ls_budat>-option EQ 'EQ'.
      <ls_budat>-high = <ls_budat>-low.
    ENDIF.

    CLEAR: gv_gjahr,gv_monat,gv_gjahr_buk,gv_monat_buk,gv_datbi,gv_datab,
           gv_partial,gv_tsfy_durum,gv_month_last,gv_error.

*  CALL FUNCTION 'BAPI_COMPANYCODE_GET_PERIOD'
*    EXPORTING
*      companycodeid = gv_bukrs
*      posting_date  = gr_budat-low
*    IMPORTING
*      fiscal_year   = gv_gjahr_buk
*      fiscal_period = gv_monat_buk.

    gv_gjahr_buk = <ls_budat>-low+0(4).
    gv_monat_buk = <ls_budat>-low+4(2).

    gv_datbi = <ls_budat>-high.
    gv_datab = <ls_budat>-low.
    gv_gjahr = gv_gjahr_buk.
    gv_monat = gv_monat_buk.

    lv_first_day = <ls_budat>-low.

    gv_month_last = last_day_of_months( lv_first_day ).

    IF lv_first_day+6(2) NE '01'.
      gv_partial = 'X'.
    ELSE.
      IF gv_month_last NE <ls_budat>-high.
        gv_partial = 'X'.
      ENDIF.
    ENDIF.

    IF gs_bukrs-tastar IS NOT INITIAL.
      IF gs_bukrs-tastar+0(4) EQ <ls_budat>-low+0(4) AND
         gs_bukrs-tastar+4(2) EQ <ls_budat>-low+4(2).

        "Tasfiye ayındaki defter oluşturma 2 aşamalı olacağından
        IF <ls_budat>-low+6(2) EQ '01'.
          lv_tastar_check = gs_bukrs-tastar - 1.
          IF <ls_budat>-high EQ lv_tastar_check.
            "Burda tasfiye öncesini oluşturacağından sorun yok
            gv_tsfy_durum = 'F'.
          ENDIF.
        ELSEIF gs_bukrs-tastar = <ls_budat>-low AND <ls_budat>-high EQ gv_month_last.
          "Tasfiye tarihinden sonraki defter için
          gv_tsfy_durum = 'L'.
        ENDIF.
      ENDIF.

*    IF gs_bukrs-tastar+0(4) EQ gv_datab+0(4) AND
*       gs_bukrs-tastar+4(2) EQ gv_datab+4(2).
*      gv_tsfy_durum = 'L'.
*    ELSE.
*      gv_tsfy_durum = 'X'.
*    ENDIF.
    ENDIF.
  ENDMETHOD.