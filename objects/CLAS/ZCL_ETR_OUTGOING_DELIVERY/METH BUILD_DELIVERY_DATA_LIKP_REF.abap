  METHOD build_delivery_data_likp_ref.
    LOOP AT ms_outdel_data-vbak INTO DATA(ls_vbak).
      APPEND INITIAL LINE TO ms_delivery_ubl-orderreference ASSIGNING FIELD-SYMBOL(<ls_order_reference>).
      <ls_order_reference>-id-content = ls_vbak-vbeln.
      CONCATENATE ls_vbak-audat+0(4)
                  ls_vbak-audat+4(2)
                  ls_vbak-audat+6(2)
        INTO <ls_order_reference>-issuedate-content
        SEPARATED BY '-'.
    ENDLOOP.
  ENDMETHOD.