  METHOD generate_transport_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_trnsp,
          lt_texts TYPE TABLE OF zetr_t_trnsx.

    lt_codes = VALUE #( ( trnsp = '1' )
                        ( trnsp = '2' )
                        ( trnsp = '3' )
                        ( trnsp = '4' )
                        ( trnsp = '5' )
                        ( trnsp = '6' )
                        ( trnsp = '7' )
                        ( trnsp = '8' ) ).

    lt_texts = VALUE #(
                        ( spras = 'T' trnsp = '1' bezei =  'Denizyolu' )
                        ( spras = 'T' trnsp = '2' bezei =  'Demiryolu' )
                        ( spras = 'T' trnsp = '3' bezei =  'Karayolu' )
                        ( spras = 'T' trnsp = '4' bezei =  'Havayolu' )
                        ( spras = 'T' trnsp = '5' bezei =  'Posta' )
                        ( spras = 'T' trnsp = '6' bezei =  'Çok araçlı' )
                        ( spras = 'T' trnsp = '7' bezei =  'Sabit taşıma tesisleri' )
                        ( spras = 'T' trnsp = '8' bezei =  'İç su taşımacılığı' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    DELETE FROM zetr_t_trnsp.
    DELETE FROM zetr_t_trnsx.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_trnsp FROM TABLE @lt_codes.
    INSERT zetr_t_trnsx FROM TABLE @lt_texts.
    COMMIT WORK AND WAIT.
  ENDMETHOD.