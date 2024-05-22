  METHOD build_delivery_data_common_hdr.
    DATA(lv_datlo) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_timlo) = cl_abap_context_info=>get_system_time( ).
    CONCATENATE lv_datlo+0(4)
                lv_datlo+4(2)
                lv_datlo+6(2)
      INTO ms_delivery_ubl-issuedate-content
      SEPARATED BY '-'.

    CONCATENATE lv_timlo+0(2)
                lv_timlo+2(2)
                lv_timlo+4(2)
                INTO ms_delivery_ubl-issuetime-content
                SEPARATED BY ':'.
  ENDMETHOD.