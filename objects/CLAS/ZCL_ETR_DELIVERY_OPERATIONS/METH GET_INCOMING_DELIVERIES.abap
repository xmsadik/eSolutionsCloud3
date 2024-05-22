  METHOD get_incoming_deliveries.
    DATA(lo_edelivery_service) = zcl_etr_edelivery_ws=>factory( mv_company_code ).
    lo_edelivery_service->get_incoming_deliveries(
      EXPORTING
        iv_date_from = iv_date_from
        iv_date_to   = iv_date_to
      IMPORTING
        et_items     = et_items
        et_list      = et_list ).
    CHECK et_list IS NOT INITIAL.
    SELECT dlvui
      FROM zetr_t_icdlv
      FOR ALL ENTRIES IN @et_list
      WHERE dlvui = @et_list-dlvui
      INTO TABLE @DATA(lt_existing).
    IF sy-subrc = 0.
      LOOP AT lt_existing INTO DATA(ls_existing).
        DELETE et_list WHERE dlvui = ls_existing-dlvui.
      ENDLOOP.
    ENDIF.
    CHECK et_list IS NOT INITIAL.
    save_incoming_deliveries( it_list  = et_list
                              it_items = et_items ).
  ENDMETHOD.