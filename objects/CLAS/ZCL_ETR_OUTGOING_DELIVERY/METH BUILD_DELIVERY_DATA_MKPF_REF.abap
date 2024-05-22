  METHOD build_delivery_data_mkpf_ref.
    LOOP AT ms_goodsmvmt_data-ekko INTO DATA(ls_ekko).
      APPEND INITIAL LINE TO ms_delivery_ubl-orderreference ASSIGNING FIELD-SYMBOL(<ls_order_reference>).
      <ls_order_reference>-id-content = ls_ekko-ebeln.
      CONCATENATE ls_ekko-bedat+0(4)
                  ls_ekko-bedat+4(2)
                  ls_ekko-bedat+6(2)
        INTO <ls_order_reference>-issuedate-content
        SEPARATED BY '-'.
    ENDLOOP.
  ENDMETHOD.