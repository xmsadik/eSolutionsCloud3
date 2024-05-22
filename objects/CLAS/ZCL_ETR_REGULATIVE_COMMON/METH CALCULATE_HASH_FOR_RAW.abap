  METHOD calculate_hash_for_raw.
    TRY.
        cl_abap_message_digest=>calculate_hash_for_raw(
          EXPORTING
            if_algorithm     = 'MD5'
            if_data          = iv_raw_data
            if_length        = xstrlen( iv_raw_data )
          IMPORTING
            ef_hashstring    = rv_calculated_hash ).
      CATCH cx_abap_message_digest.
    ENDTRY.
  ENDMETHOD.