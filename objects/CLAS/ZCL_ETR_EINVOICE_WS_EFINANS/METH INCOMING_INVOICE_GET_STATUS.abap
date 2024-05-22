  METHOD incoming_invoice_get_status.
    DATA: ls_invoice_status TYPE mty_document_status.
    ls_invoice_status = get_incoming_invoice_stat_int( is_document_numbers-duich ).

    rs_status-staex = ls_invoice_status-yanitgonderimcevabidetayi.
    rs_status-radsc = ls_invoice_status-yanitgonderimcevabikodu.
    IF ls_invoice_status-kepdurum = '1'.
      rs_status-resst = 'K'.
    ELSEIF ls_invoice_status-gibiptaldurum = '1'.
      rs_status-resst = 'G'.
    ELSEIF ls_invoice_status-yanitdurumu = '-1'.
      rs_status-resst = 'X'.
    ELSE.
      rs_status-resst = ls_invoice_status-yanitdurumu.
    ENDIF.
    rs_status-apres = SWITCH #( rs_status-resst WHEN '2' THEN 'KABUL' WHEN '1' THEN 'RED' ELSE '' ).
  ENDMETHOD.