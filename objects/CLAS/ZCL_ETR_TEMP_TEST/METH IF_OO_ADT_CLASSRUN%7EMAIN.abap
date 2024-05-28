  METHOD if_oo_adt_classrun~main.
    DATA lv_amount TYPE wrbtr_cs VALUE '5011101034.05'.
    DATA(lv_words) = zcl_etr_regulative_common=>amount_to_words( lv_amount ).
    out->write( lv_words ).
  ENDMETHOD.