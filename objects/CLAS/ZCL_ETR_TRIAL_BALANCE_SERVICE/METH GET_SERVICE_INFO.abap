  METHOD get_service_info.
    SELECT *
      FROM zetr_t_serv_user
     WHERE service_id EQ '01'
      INTO TABLE @mt_users.
  ENDMETHOD.