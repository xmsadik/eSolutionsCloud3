  METHOD incoming_delivery_get_status.
    DATA(ls_delivery_status) = get_incoming_delivery_stat_int( is_document_numbers-duich ).
    rs_status-staex = ls_delivery_status-yanitgonderimcevabidetayi.
    rs_status-radsc = ls_delivery_status-yanitgonderimcevabikodu.
    rs_status-ruuid = ls_delivery_status-yanitettn.
    CASE ls_delivery_status-yanitdurumu.
      WHEN '0'.
        rs_status-resst = '0'.
      WHEN '-1'.
        rs_status-resst = 'X'.
      WHEN '1' OR '2'.
        rs_status-resst = '1'.
      WHEN OTHERS.
        CLEAR rs_status-resst.
    ENDCASE.
  ENDMETHOD.