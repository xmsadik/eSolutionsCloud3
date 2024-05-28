  METHOD number_to_words.
    DATA: c_ones TYPE TABLE OF string,
          c_tens TYPE TABLE OF string.

    APPEND 'Bir' TO c_ones.
    APPEND 'İki' TO c_ones.
    APPEND 'Üç' TO c_ones.
    APPEND 'Dört' TO c_ones.
    APPEND 'Beş' TO c_ones.
    APPEND 'Altı' TO c_ones.
    APPEND 'Yedi' TO c_ones.
    APPEND 'Sekiz' TO c_ones.
    APPEND 'Dokuz' TO c_ones.

    APPEND 'On' TO c_tens.
    APPEND 'Yirmi' TO c_tens.
    APPEND 'Otuz' TO c_tens.
    APPEND 'Kırk' TO c_tens.
    APPEND 'Elli' TO c_tens.
    APPEND 'Altmış' TO c_tens.
    APPEND 'Yetmiş' TO c_tens.
    APPEND 'Seksen' TO c_tens.
    APPEND 'Doksan' TO c_tens.

    CASE strlen( number ).
      WHEN 1.
        words = VALUE #( c_ones[ number ] OPTIONAL ).
      WHEN 2.
        words = COND string( WHEN number(1) <> '0' THEN VALUE #( c_tens[ number(1) ] OPTIONAL ) ) &&
                COND string( WHEN number+1(1) <> '0' THEN VALUE #( c_ones[ number+1(1) ] OPTIONAL ) ).
      WHEN 3.
        words = COND string( WHEN number(1) <> '1' AND number(1) <> '0' THEN VALUE #( c_ones[ number(1) ] OPTIONAL ) ) && COND string( WHEN number(1) <> '0' THEN 'Yüz' ) &&
                COND string( WHEN number+1(1) <> '0' THEN VALUE #( c_tens[ number+1(1) ] OPTIONAL ) ) &&
                COND string( WHEN number+2(1) <> '0' THEN VALUE #( c_ones[ number+2(1) ] OPTIONAL ) ).
    ENDCASE.
  ENDMETHOD.