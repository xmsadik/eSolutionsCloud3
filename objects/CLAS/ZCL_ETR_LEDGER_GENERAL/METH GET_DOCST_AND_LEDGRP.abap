  METHOD get_docst_and_ledgrp.
*  DATA: ls_t881        LIKE t881,
*        lv_fagl_active TYPE c LENGTH 1,
*        lt_bstat       LIKE /itetr/edf_bldbk OCCURS 0 WITH HEADER LINE.

*  DATA: BEGIN OF lt_ldgrp OCCURS 0,
*          ldgrp TYPE bkpf-ldgrp,
*        END OF lt_ldgrp.

    CLEAR:gr_bstat,gr_bstat[],gr_ldgrp,gr_ldgrp[].

    IF gs_bukrs-rldnr IS NOT INITIAL.
      SELECT SINGLE *
        FROM I_Ledger
       WHERE Ledger  EQ @gs_bukrs-rldnr
         AND IsLeadingLedger NE 'X'
         INTO @DATA(ls_t881).
      IF sy-subrc EQ 0.
        CLEAR :gr_bstat.
        gr_bstat = VALUE #( sign = 'I' option = 'EQ' ( low = 'L' ) ( low = '' ) ).

*      CALL FUNCTION 'FAGL_CHECK_GLFLEX_ACTIV_CLIENT'
*        EXPORTING
*          client          = sy-mandt
*        IMPORTING
*          e_glflex_active = lv_fagl_active
*        EXCEPTIONS
*          error_in_setup  = 1
*          OTHERS          = 2.
*      IF sy-subrc <> 0.
*      ENDIF.
*
*      IF lv_fagl_active EQ 'X'.
*        SELECT ldgrp
*          FROM fagl_tldgrp_map
*          INTO TABLE lt_ldgrp
*         WHERE rldnr EQ gs_bukrs-rldnr.
*      ELSE.
*        SELECT ldgrp
*          FROM tldgrp_map
*          INTO TABLE lt_ldgrp
*         WHERE rldnr EQ gs_bukrs-rldnr.
*      ENDIF.

*      LOOP AT lt_ldgrp.
*        gr_ldgrp     = 'IEQ'.
*        gr_ldgrp-low = lt_ldgrp-ldgrp.
*        APPEND gr_ldgrp.CLEAR gr_ldgrp.
*      ENDLOOP.

*      gr_ldgrp = VALUE #( sign = 'I' option = 'EQ' ( low = '' ) ( low = gv_ledger ) ).
*      APPEND gr_ldgrp.CLEAR gr_ldgrp.
      ELSE.

*      IF gs_params-xhana IS NOT INITIAL.
*        SELECT ldgrp
*          FROM fagl_tldgrp_map
*          INTO TABLE lt_ldgrp
*         WHERE rldnr EQ gs_bukrs-rldnr.
*
*        LOOP AT lt_ldgrp.
*          gr_ldgrp     = 'IEQ'.
*          gr_ldgrp-low = lt_ldgrp-ldgrp.
*          APPEND gr_ldgrp.CLEAR gr_ldgrp.
*        ENDLOOP.
*
*        gr_ldgrp = 'IEQ '.
*        APPEND gr_ldgrp.CLEAR gr_ldgrp.
*      ENDIF.
*
*      gr_bstat = 'IEQ '.
*      APPEND gr_bstat.CLEAR gr_bstat.
*
*      gr_bstat = 'IEQU'.
*      APPEND gr_bstat.CLEAR gr_bstat.
      ENDIF.
    ENDIF.

    SELECT 'I' AS sign, 'EQ' AS option, bstat AS low
      FROM zetr_t_bldbk
     WHERE bukrs = @gv_bukrs
     INTO TABLE @gr_bstat.
  ENDMETHOD.