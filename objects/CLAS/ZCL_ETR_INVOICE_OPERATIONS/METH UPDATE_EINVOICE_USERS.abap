  METHOD update_einvoice_users.
    rt_list = zcl_etr_einvoice_ws=>factory( mv_company_code )->download_registered_taxpayers( ).
    IF rt_list IS NOT INITIAL.
      SELECT taxid, aliass
        FROM zetr_t_inv_ruser
        WHERE defal = @abap_true
        INTO TABLE @DATA(lt_default_aliases).
      SORT lt_default_aliases BY taxid aliass.

      SORT rt_list BY taxid.
      DATA: lv_taxid     TYPE zetr_e_taxid,
            lv_record_no TYPE buzei.
      LOOP AT rt_list ASSIGNING FIELD-SYMBOL(<ls_taxpayer>).
        IF lv_taxid <> <ls_taxpayer>-taxid.
          lv_taxid = <ls_taxpayer>-taxid.
          CLEAR lv_record_no.
        ENDIF.
        lv_record_no += 1.
        <ls_taxpayer>-recno = lv_record_no.

        IF lt_default_aliases IS NOT INITIAL.
          READ TABLE lt_default_aliases
              WITH KEY taxid = <ls_taxpayer>-taxid
                       aliass = <ls_taxpayer>-aliass
              BINARY SEARCH
              TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            <ls_taxpayer>-defal = abap_true.
          ENDIF.
        ENDIF.
      ENDLOOP.
      CHECK iv_db_write = abap_true.
      DELETE FROM zetr_t_inv_ruser.
*      COMMIT WORK AND WAIT.
      INSERT zetr_t_inv_ruser FROM TABLE @rt_list.
*      COMMIT WORK AND WAIT.
    ELSE.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e004(zetr_common).
    ENDIF.
  ENDMETHOD.