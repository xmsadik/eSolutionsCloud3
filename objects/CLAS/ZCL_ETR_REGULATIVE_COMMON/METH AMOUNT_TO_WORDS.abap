  METHOD amount_to_words.
    TYPES: BEGIN OF ty_splitted,
             index  TYPE i,
             number TYPE string,
             words  TYPE string,
           END OF ty_splitted.
    DATA: lv_number   TYPE string,
          lv_decimal  TYPE string,
          lt_splitted TYPE STANDARD TABLE OF ty_splitted,
          lv_offset   TYPE i.
    lv_number = trunc( amount ).
    lv_decimal = frac( amount ).
    SHIFT lv_decimal LEFT DELETING LEADING '0'.
    SHIFT lv_decimal LEFT DELETING LEADING '.'.
    CONDENSE: lv_number, lv_decimal.
    WHILE lv_number IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_splitted ASSIGNING FIELD-SYMBOL(<ls_splitted>).
      <ls_splitted>-index = sy-index.
      IF strlen( lv_number ) <= 3.
        <ls_splitted>-number = lv_number.
        CLEAR lv_number.
      ELSE.
        lv_offset = strlen( lv_number ) - 3.
        <ls_splitted>-number = lv_number+lv_offset(3).
        lv_number = lv_number(lv_offset).
      ENDIF.
    ENDWHILE.

    SORT lt_splitted BY index DESCENDING.
    LOOP AT lt_splitted ASSIGNING <ls_splitted>.
      <ls_splitted>-words = number_to_words( <ls_splitted>-number ).
    ENDLOOP.

    LOOP AT lt_splitted ASSIGNING <ls_splitted>.
      CASE <ls_splitted>-index.
        WHEN 1."yüz
          words = words && <ls_splitted>-words.
        WHEN 2."bin
          words = words && COND string( WHEN <ls_splitted>-number <> '001' AND <ls_splitted>-number <> '01' AND <ls_splitted>-number <> '1' THEN <ls_splitted>-words && 'Bin' ELSE 'Bin' ).
        WHEN 3."milyon
          words = words && <ls_splitted>-words && 'Milyon'.
        WHEN 4."milyar
          words = words && <ls_splitted>-words && 'Milyar'.
        WHEN 5."trilyon
          words = words && <ls_splitted>-words && 'Trilyon'.
      ENDCASE.
    ENDLOOP.

    IF currency EQ 'EUR'.
      words = words && ` EUR ` && number_to_words( lv_decimal ) && ` Cent`.
    ELSEIF currency EQ 'USD'.
      words = words && ` USD ` && number_to_words( lv_decimal ) && ` Cent`.
    ELSE.
      words = words && ` TL ` && number_to_words( lv_decimal ) && ` Kuruş`.
    ENDIF.

  ENDMETHOD.