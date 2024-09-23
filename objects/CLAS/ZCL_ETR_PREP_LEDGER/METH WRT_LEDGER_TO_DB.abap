  METHOD wrt_ledger_to_db.


*    TRY.
*
*        TYPES : BEGIN OF ty_t001,
*                  ktopl TYPE c LENGTH 4,
*                  ktop2 TYPE c LENGTH 4,
*                END OF ty_t001.
*
*        TYPES: BEGIN OF ty_blart_range,
*                 sign   TYPE c LENGTH 1,
*                 option TYPE c LENGTH 2,
*                 low    TYPE blart,
*                 high   TYPE blart,
*               END OF ty_blart_range.
*
*        TYPES: BEGIN OF ty_hkont,
*                 sign   TYPE c LENGTH 1,
*                 option TYPE c LENGTH 2,
*                 low    TYPE hkont,
*                 high   TYPE hkont,
*               END OF ty_hkont.
*
*        TYPES : BEGIN OF ty_skb1,
*                  altkt TYPE saknr,
*                  saknr TYPE c LENGTH 10,
*                END OF ty_skb1.
*
*        TYPES: BEGIN OF ty_blart,
*                 blart   TYPE zetr_t_beltr-blart,
*                 blart_t TYPE zetr_t_beltr-blart_t,
*                 gbtur   TYPE zetr_t_beltr-gbtur,
*                 oturu   TYPE zetr_t_beltr-oturu,
**                 nouse   TYPE zetr_t_beltr-nouse,
*                 refob   TYPE c LENGTH 1,
*                 ocblg   TYPE zetr_t_beltr-ocblg,
*               END OF ty_blart.
*
*        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
*
*        DATA : ls_bukrs       TYPE zetr_t_srkdb,
*               ls_params      TYPE zetr_t_dopvr,
*               lv_alternative TYPE c LENGTH 1,
*               ls_t001        TYPE ty_t001,
**               lt_smm         TYPE TABLE OF zetr_t_symmb,
*               lrs_ablart     TYPE ty_blart_range,
*               lr_ablart      TYPE TABLE OF  ty_blart_range,
*               lrs_kblart     TYPE ty_blart_range,
*               lr_kblart      TYPE TABLE OF ty_blart_range,
*               lrs_blart      TYPE ty_blart_range,
*               lr_blart       TYPE TABLE OF ty_blart_range,
*               lrs_hkont      TYPE ty_hkont,
*               lr_hkont       TYPE TABLE OF ty_hkont,
*               lt_skb1        TYPE TABLE OF ty_skb1,
*               lt_blart       TYPE TABLE OF ty_blart,
*               ls_blart       TYPE ty_blart,
*               lv_bukrs       TYPE bukrs,
*               lv_gjahr       TYPE gjahr,
*               lv_monat       TYPE monat.
*
*
*
*        LOOP AT lt_filter INTO DATA(ls_filter).
*          CASE ls_filter-name.
*            WHEN 'BUKRS'.
*              lv_bukrs = ls_filter-range[ 1 ]-low .
*            WHEN 'GJAHR'.
*              lv_gjahr =  ls_filter-range[ 1 ]-low .
*            WHEN 'MONAT'.
*              lv_monat  = ls_filter-range[ 1 ]-low .
*          ENDCASE.
*        ENDLOOP.
*
**********************************************  PERFORM get_company  ******************************************
*
*        SELECT SINGLE *
*       FROM zetr_t_srkdb
*       WHERE bukrs = @lv_bukrs
*       INTO  @ls_bukrs.
*
*
**  gv_bukrs_tmp = gv_bukrs.
**
**  IF gs_bukrs-maxcr IS INITIAL.
**    "Open Cursor BKPF Select Sayısı
**    gs_bukrs-maxcr = 5000.
**  ENDIF.
**
**  IF gv_bcode IS NOT INITIAL. Kullanılmıyor @YiğitcanÖ.
**    SELECT SINGLE *
**      FROM /itetr/edf_sbblg
**      INTO gs_bcode
**     WHERE bukrs = gv_bukrs
**       AND bcode = gv_bcode.
**
**    IF ( gs_bcode-sub_bukrs IS NOT INITIAL AND
**         gs_bcode-sub_gsber IS INITIAL ) OR
**       gs_bcode-btype EQ 'BUKRS'.
**
**      gv_bukrs     = gs_bcode-sub_bukrs.
**      gv_bukrs_tmp = gs_bcode-bukrs.
**
**      gs_bukrs-adress1     = gs_bcode-adress1.
**      gs_bukrs-adress2     = gs_bcode-adress2.
**      gs_bukrs-house_num   = gs_bcode-house_num.
**      gs_bukrs-postal_code = gs_bcode-postal_code.
**      gs_bukrs-city        = gs_bcode-city.
**      gs_bukrs-country_u   = gs_bcode-country.
**      gs_bukrs-tel_number  = gs_bcode-tel_number.
**      gs_bukrs-fax_number  = gs_bcode-fax_number.
**      gs_bukrs-email       = gs_bcode-email.
**      gs_bukrs-creator     = gs_bcode-creator.
**      gs_bukrs-days45      = gs_bcode-days45.
**    ENDIF.
**  ENDIF.
*
*
*        IF ls_bukrs-creator IS INITIAL.
*
*          DATA(lv_bname) = cl_abap_context_info=>get_user_technical_name( ).
*
*          SELECT SINGLE i_personaddress~givenname,i_personaddress~familyname
*           FROM i_personaddress
*          INNER JOIN i_user ON i_personaddress~addresspersonid = i_user~addresspersonid
*
*          WHERE i_user~userid = @lv_bname
*          INTO (@DATA(lv_first),@DATA(lv_last)).
*
*          CONCATENATE lv_first lv_last
*                 INTO ls_bukrs-creator SEPARATED BY space.
*        ENDIF.
*
*
*        SELECT SINGLE *
*          FROM zetr_t_dopvr
*         WHERE bukrs = @lv_bukrs
**           AND bcode = gv_bcode
*           INTO @ls_params.
*
*        SELECT SINGLE countrychartofaccounts AS ktop2
*          FROM i_companycode
*         WHERE companycode = @lv_bukrs
*         INTO @ls_t001.
*
*        IF ls_t001-ktop2 IS NOT INITIAL.
*          lv_alternative = 'X'.
*          ls_t001-ktopl  = ls_t001-ktop2.
*        ENDIF.
*
*        IF ls_bukrs-ktopl IS NOT INITIAL.
*          ls_t001-ktopl  = ls_bukrs-ktopl.
*          lv_alternative = space.
*        ENDIF.
*
*        IF ls_bukrs-maxit IS INITIAL.
*          ls_bukrs-maxit = 20000.
*        ENDIF.
*
**        SELECT *
**          FROM zetr_t_symmb
**         WHERE bukrs = @lv_bukrs
**          INTO TABLE @lt_smm.
*
*        IF ls_params-waers IS INITIAL.
*          DATA(lv_waers) = 'TRY'.
*        ELSE.
*          lv_waers = ls_params-waers.
*        ENDIF.
*
*
*        SELECT *
*      FROM zetr_t_hespl
*      WHERE ktopl = @ls_t001-ktopl
*      INTO TABLE @DATA(lt_hspplan).
*
*
**        SELECT *
**    FROM skat
**    INTO TABLE gt_skat
**   WHERE ktopl = gs_t001-ktopl.
**  IF sy-subrc NE 0 AND gs_bukrs-ktopl IS NOT INITIAL.
**    SELECT skat~spras skat~ktopl skat~saknr
**           skat~txt20 skat~txt50 skat~mcod1
**      FROM skat
**     INNER JOIN t001 ON t001~ktopl = skat~ktopl
**      INTO CORRESPONDING FIELDS OF TABLE gt_skat
**     WHERE bukrs = gs_t001-bukrs.
**  ENDIF.
*
**DELETE gt_skat WHERE spras NE 'T'.
*
*        IF ls_bukrs-ablart IS NOT INITIAL.
*          lrs_ablart-sign    = 'I'.
*          lrs_ablart-option  = 'EQ'.
*          lrs_ablart-low = ls_bukrs-ablart.
*          APPEND lrs_ablart TO lr_ablart.CLEAR lrs_ablart.
*        ENDIF.
*
*        IF ls_bukrs-kblart IS NOT INITIAL.
*          lrs_kblart-sign     = 'I'.
*          lrs_kblart-option     = 'EQ'.
*          lrs_kblart-low = ls_bukrs-kblart.
*          APPEND lrs_kblart TO lr_kblart.CLEAR lrs_kblart.
*        ENDIF.
*
**********************************************  PERFORM get_company  ************************************************
*
**********************************************  PERFORM get_business_areas  ****************************************** Kullanılmadı
*
**********************************************  PERFORM get_docst_and_ledgrp  ****************************************
*
***Belge Durumu Bakımı yapılıyor mu yapılmıyor mu ?
***/ITETR/EDF_BLDBK - gr_bstat
*
**********************************************  PERFORM get_docst_and_ledgrp  ****************************************
*
**********************************************  PERFORM get_accounts  ****************************************
*
*
*        SELECT ssign AS sign,
*               soptn AS option,
*               splow AS low,
*               shigh AS high
*          FROM zetr_t_hesbk
*         WHERE bukrs = @lv_bukrs
*           AND ktopl = @ls_t001-ktopl
*            INTO CORRESPONDING FIELDS OF TABLE  @lr_hkont.
**
*        SELECT alternativeglaccount AS altkt,
*               glaccount AS saknr
*          FROM i_glaccountincompanycode
*         WHERE companycode = @lv_bukrs
*         INTO CORRESPONDING FIELDS OF TABLE @lt_skb1.
*
*
**********************************************  PERFORM get_accounts  ****************************************
*
*********************************************   PERFORM set_date  ****************************************
*
**Şirket kodu bilgileri tablosu Tasfiye Tarihi(tastar) bilgileri doldurulmayacağından dolayı gerek duymadım.  &gv_tsfy_durum @YiğitcanÖ.
*
**********************************************  PERFORM set_date  ****************************************
*
**********************************************  PERFORM set_blart  ****************************************
*
*        SELECT *
*          FROM zetr_t_beltr
*          INTO CORRESPONDING FIELDS OF TABLE @lt_blart.
*
**            SELECT *  *İletilen dökümanda yok. Sor -Referans Belgesi Zorunlu Gib Belge Türleri
**    FROM /itetr/edf_rbzgb
**    INTO TABLE gt_check_ref
**   WHERE bukrs = gv_bukrs.
*
*
**  LOOP AT gt_blart.
**    READ TABLE gt_check_ref WITH KEY gbtur = gt_blart-gbtur.
**    IF sy-subrc EQ 0.
**      gt_blart-refob = 'X'.
**      MODIFY gt_blart.
**    ENDIF.
**  ENDLOOP.
*
*        LOOP AT lt_blart INTO DATA(ls_blart2).
*          lrs_blart-sign     = 'I'.
*          lrs_blart-option     = 'EQ'.
*          lrs_blart-low = ls_blart2-blart.
*          COLLECT lrs_blart INTO lr_blart .CLEAR lrs_blart.
*
*          IF ls_blart2-ocblg EQ 'O'.
*            lrs_ablart-sign     = 'I'.
*            lrs_ablart-option     = 'EQ'.
*            lrs_ablart-low = ls_blart2-blart.
*            COLLECT lrs_ablart INTO lr_ablart .CLEAR lrs_ablart.
*          ELSEIF ls_blart2-ocblg EQ 'C'.
*            lrs_kblart-sign    = 'I'.
*            lrs_kblart-option     = 'EQ'.
*            lrs_kblart-low = ls_blart2-blart.
*            COLLECT lrs_kblart INTO lr_kblart.CLEAR lrs_kblart.
*          ENDIF.
*        ENDLOOP.
*
*
*
*
**********************************************  PERFORM set_blart  ****************************************
*
*
**GV_F51_TCODE,GV_F51_BLART
*
*
*******************************************************
*
**********************************************  Create  ****************************************
*        TYPES : BEGIN OF ty_bkpf ,
*                  bukrs TYPE bukrs,
*                  belnr TYPE belnr_d,
*                  gjahr TYPE gjahr,
*                  blart TYPE blart,
*                  awtyp TYPE c LENGTH 5,
*                  awkey TYPE c LENGTH 20,
*                  stblg TYPE belnr_d,
*                  xblnr TYPE xblnr1,
*                  bstat TYPE zetr_e_bstat,
*                  tcode TYPE tcode,
*                  bktxt TYPE bktxt,
*                  budat TYPE budat,
*                  bldat TYPE bldat,
*                  rldnr TYPE fins_ledger,
*
*                END OF ty_bkpf.
*
*        TYPES: BEGIN OF ty_dybel,
*                 bukrs TYPE bukrs,
*                 belnr TYPE belnr_d,
*                 gjahr TYPE gjahr,
*               END OF ty_dybel.
*
*        TYPES: BEGIN OF ty_blryb,
*                 bukrs TYPE bukrs,
*                 blart TYPE blart,
*               END OF ty_blryb.
*
*        DATA : lt_bkpf      TYPE SORTED TABLE OF ty_bkpf WITH UNIQUE KEY bukrs belnr gjahr bstat awtyp,
*               lt_bkpf_temp TYPE TABLE OF ty_bkpf WITH EMPTY KEY.
*
*        DATA : lt_ex_docs      TYPE TABLE OF zetr_t_dybel,
*               lt_ex_docs_temp TYPE TABLE OF ty_dybel WITH EMPTY KEY.
*
*        DATA : lt_copy_belnr      TYPE TABLE OF zetr_t_blryb,
*               lt_copy_belnr_temp TYPE TABLE OF ty_blryb WITH EMPTY KEY.
*
*        DATA : lv_begda_temp TYPE datum.
*        DATA : lv_endda_temp TYPE datum.
*
*        DATA: lr_budat TYPE RANGE OF budat.
*        DATA: lrs_budat LIKE LINE OF lr_budat.
*
*        IF lv_gjahr IS NOT INITIAL AND lv_monat IS NOT INITIAL.
*          DATA(lv_begda) = lv_gjahr && lv_monat && '01'.
*          DATA(lv_endda) = lv_gjahr && lv_monat && '01'.
*
*          lv_begda_temp = lv_begda.
*
*          zinf_regulative_common=>rp_last_day_of_months(
*            EXPORTING
*              day_in            = lv_begda_temp
*            IMPORTING
*              last_day_of_month = lv_endda_temp
*            EXCEPTIONS
*              day_in_no_date    = 1
*              OTHERS            = 2
*          ).
*        ENDIF.
*
*        IF lv_endda_temp IS NOT INITIAL.
*          lv_endda  = lv_endda_temp.
*        ENDIF.
*
*        IF lv_endda IS NOT INITIAL AND lv_begda IS NOT INITIAL.
*          lrs_budat-sign     = 'I'.
*          lrs_budat-option   = 'BT'.
*          lrs_budat-low      = lv_begda.
*          lrs_budat-low      = lv_endda.
*          APPEND lrs_budat TO lr_budat.CLEAR lrs_budat.
*        ENDIF.
*
*
*        SELECT * FROM zetr_t_blryb WHERE bukrs = @lv_bukrs INTO TABLE @lt_copy_belnr.
*        SELECT * FROM zetr_t_dybel WHERE bukrs = @lv_bukrs INTO TABLE @lt_ex_docs.
*
*
*        SELECT companycode AS bukrs,
*               accountingdocument AS belnr ,
*               fiscalyear AS gjahr ,
*               accountingdocumenttype AS blart ,
*               referencedocumenttype AS awtyp ,
*               originalreferencedocument AS awkey ,
*               reversedocument AS stblg ,
*               documentreferenceid AS xblnr ,
*               accountingdocumentcategory AS bstat ,
*               transactioncode AS tcode ,
*               accountingdocumentheadertext AS bktxt ,
*               postingdate AS budat ,
*               documentdate AS bldat ,
*               ledger AS rldnr
*          FROM i_journalentry
*         WHERE companycode EQ @lv_bukrs
**           AND belnr IN gr_belnr Kullanılmıyor YiğitcanÖ.
*           AND postingdate IN @lr_budat
**             AND bstat IN gr_bstat Bakılacak ! YiğitcanÖ
**           AND ldgrp IN gr_ldgrp Bakılacak ! YiğitcanÖ
*           AND accountingdocumenttype IN @lr_blart
*           INTO TABLE @lt_bkpf.
*
*
*        lt_bkpf_temp = lt_bkpf.
*        lt_ex_docs_temp = lt_ex_docs.
*        lt_copy_belnr_temp = lt_copy_belnr.
*
**        zcl_etr_ledger_create=>create(
**        EXPORTING
**         is_params      = ls_params
**         is_bukrs       =  ls_bukrs
**         iv_bukrs       = lv_bukrs
**         iv_gjahr       = lv_gjahr
***           IV_BCODE
**         iv_monat       = lv_monat
**         iv_alternative = lv_alternative
**        iv_f51_blart    = ''
**        iv_f51_tcode    = ''
**        iv_tasfiye      = '' "YiğitcanÖ. /ITETR/EDF_LEDGER_CREATE_CONTR fonksiyonundan doluyor ? zorunlu mu sor /ITETR/EDF_DEFKY- TSFYD Tasfiye Halindeki Defter
**        iv_ledger       = '' "boş gönderiliyor üründe
**        CHANGING
**        t_bkpf          =  lt_bkpf_temp
**        t_ex_docs       = lt_ex_docs_temp
***        T_WRONG_TYPES type zetr_t_BTHBL "Kullanılmıyor @YiğitcanÖ.
**        t_copy_belnr    = lt_copy_belnr_temp
***        T_CASH
**        tr_hkont        = lr_hkont
***        tr_gsber       =  "Kullanılmıyor @YiğitcanÖ.
***        t_ledger       =  "Kullanılmıyor @YiğitcanÖ.
**        t_skb1          = lt_skb1        ).
*
*
*
*
*
*      CATCH cx_rap_query_filter_no_range.
*
*    ENDTRY.



*********************************************  Create  ****************************************

  ENDMETHOD.