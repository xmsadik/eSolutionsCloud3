  METHOD get_business_areas.
*  DATA: lt_bareas TYPE TABLE OF zetr_t_srisa .
*
*  CLEAR:gr_gsber,gr_gsber[].
*
*  SELECT *
*    FROM /itetr/edf_srisa
*    INTO TABLE lt_bareas
*   WHERE bukrs = gv_bukrs
*     AND bcode = gv_bcode.
*
*  IF gv_bcode IS NOT INITIAL.
*    IF gs_bcode-sub_gsber IS NOT INITIAL.
*      gr_gsber     = 'IEQ'.
*      gr_gsber-low = gs_bcode-sub_gsber.
*      APPEND gr_gsber.CLEAR gr_gsber.
*    ENDIF.
*  ENDIF.
*
*  LOOP AT lt_bareas.
*    gr_gsber     = 'IEQ'.
*    gr_gsber-low = lt_bareas-gsber.
*    APPEND gr_gsber.CLEAR gr_gsber.
*  ENDLOOP.
*
*  SORT gr_gsber BY low.
*  DELETE ADJACENT DUPLICATES FROM gr_gsber COMPARING low.
  ENDMETHOD.