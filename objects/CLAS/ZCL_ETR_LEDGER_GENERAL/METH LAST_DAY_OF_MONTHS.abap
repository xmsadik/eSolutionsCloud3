  METHOD last_day_of_months.
    DATA lv_month TYPE monat.
    DATA lv_year TYPE gjahr.
    IF day_in+4(2) = '12'.
      lv_month = '01'.
      lv_year = day_in(4) + 1.
    ELSE.
      lv_month = day_in+4(2) + 1.
      lv_year = day_in(4).
    ENDIF.
    last_day_of_month = lv_year && lv_month && '01'.
    last_day_of_month -= 1.
  ENDMETHOD.