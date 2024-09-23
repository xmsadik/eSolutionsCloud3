CLASS zcl_etr_ledger_general DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_blart,
             blart   TYPE zetr_t_beltr-blart,
             blart_t TYPE zetr_t_beltr-blart_t,
             gbtur   TYPE zetr_t_beltr-gbtur,
             oturu   TYPE zetr_t_beltr-oturu,
             refob   TYPE c LENGTH 1,
             ocblg   TYPE zetr_t_beltr-ocblg,
           END OF ty_blart,

           BEGIN OF ty_t001,
             bukrs TYPE bukrs,
             waers TYPE waers,
             ktopl TYPE ktopl,
             ktop2 TYPE ktopl,
           END OF ty_t001,

           BEGIN OF ty_skb1,
             saknr TYPE saknr,
           END OF ty_skb1,

           BEGIN OF ty_skat,
             saknr TYPE saknr,
             txt50 TYPE zetr_e_descr,
           END OF TY_SKat,

           ty_bapiret2_tab TYPE STANDARD TABLE OF bapiret2,
           ty_ledger_lines TYPE STANDARD TABLE OF zetr_t_defky,
           ty_datum_range  TYPE RANGE OF datum,
           ty_belnr_range  TYPE RANGE OF belnr_d.

    DATA:
      gs_t001        TYPE ty_t001,
      gv_bukrs       TYPE bukrs,
      gv_bukrs_tmp   TYPE bukrs,
      gv_bcode       TYPE zetr_e_bcode,
      gv_gjahr       TYPE gjahr,
      gv_gjahr_buk   TYPE gjahr,
      gv_monat       TYPE monat,
      gv_monat_buk   TYPE monat,
      gv_error       TYPE c LENGTH 1,
      gt_return      TYPE TABLE OF bapiret2,
      gs_bukrs       TYPE zetr_t_srkdb,
      gv_waers       TYPE waers,
      gv_alternative TYPE c LENGTH 1,
      gs_params      TYPE zetr_t_dopvr,
      gv_tasfiye     TYPE c LENGTH 1,
      gv_tsfy_durum  TYPE c LENGTH 1,
      gt_skb1        TYPE SORTED TABLE OF ty_skb1 WITH UNIQUE KEY saknr,
      gt_blart       TYPE SORTED TABLE OF ty_blart WITH UNIQUE KEY blart,
      gv_f51_blart   TYPE blart,
      gv_f51_tcode   TYPE tcode,
      gv_datbi       TYPE datbi,
      gv_datab       TYPE datab,
*      gs_defter      TYPE /itetr/edf_s_edefter_json,
      gt_ledger_part TYPE TABLE OF zetr_t_defky,
      gv_partn_n     TYPE n LENGTH 6,
      gv_initpart    TYPE c LENGTH 1,
      gv_opening     TYPE c LENGTH 1,
      gv_closing     TYPE c LENGTH 1,
      gv_count_datab TYPE datum,
      gv_first       TYPE c LENGTH 1,
      gs_yevno       TYPE zetr_t_oldef,
      gv_partn       TYPE zetr_t_defky-partn,
      gt_hspplan     TYPE SORTED TABLE OF zetr_t_hespl WITH NON-UNIQUE KEY saknr,
      gt_skat        TYPE SORTED TABLE OF ty_skat WITH NON-UNIQUE KEY saknr,
      gv_partial     TYPE c LENGTH 1,
      gv_month_last  TYPE datum,
*      gt_username    TYPE SORTED TABLE OF v_usr_name WITH NON-UNIQUE KEY bname WITH HEADER LINE,
      gv_ledger      TYPE c LENGTH 1,
      gt_ledger      TYPE TABLE OF zetr_t_defky,
      gv_conts       TYPE c LENGTH 1,
      gv_results     TYPE c LENGTH 1,

      gv_xml         TYPE c LENGTH 1,
      gv_pdf         TYPE c LENGTH 1,
      gv_html        TYPE c LENGTH 1,

      gv_yev         TYPE c LENGTH 1,
      gv_yvb         TYPE c LENGTH 1,
      gv_gib_yvb     TYPE c LENGTH 1,
      gv_keb         TYPE c LENGTH 1,
      gv_kbb         TYPE c LENGTH 1,
      gv_gib_kbb     TYPE c LENGTH 1,
      gv_rap         TYPE c LENGTH 1,

      gv_yev_sel     TYPE c LENGTH 1,
      gv_yvb_sel     TYPE c LENGTH 1,
      gv_gib_yvb_sel TYPE c LENGTH 1,
      gv_keb_sel     TYPE c LENGTH 1,
      gv_kbb_sel     TYPE c LENGTH 1,
      gv_gib_kbb_sel TYPE c LENGTH 1,
      gv_rap_sel     TYPE c LENGTH 1,

      gv_subrc       TYPE sy-subrc,
      gr_budat       TYPE RANGE OF datum,
      gr_belnr       TYPE RANGE OF belnr_d,
      gr_gsber       TYPE RANGE OF gsber,
      gr_bstat       TYPE RANGE OF zetr_e_bstat,
      gr_ldgrp       TYPE RANGE OF fins_ledger,
      gr_hkont       TYPE RANGE OF saknr,
      gr_blart       TYPE RANGE OF blart,
      gr_ablart      TYPE RANGE OF blart,
      gr_kblart      TYPE RANGE OF blart.

    CLASS-METHODS:
      factory
        IMPORTING
          !iv_company_code TYPE bukrs
        RETURNING
          VALUE(ro_object) TYPE REF TO zcl_etr_ledger_general
        RAISING
          zcx_etr_regulative_exception .

    METHODS:
      generate_ledger_data
        IMPORTING
          i_bukrs   TYPE bukrs
          i_bcode   TYPE zetr_e_BCODE
          i_tsfyd   TYPE zetr_e_edf_ledger_in_purge
          i_ledger  TYPE abap_boolean
          tr_budat  TYPE ty_datum_range
          tr_belnr  TYPE ty_belnr_range
        EXPORTING
          te_return TYPE ty_bapiret2_tab
          te_ledger TYPE ty_ledger_lines.
