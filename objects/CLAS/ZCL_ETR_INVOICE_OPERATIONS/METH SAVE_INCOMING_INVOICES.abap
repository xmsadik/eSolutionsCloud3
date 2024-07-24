  METHOD save_incoming_invoices.
    INSERT zetr_t_icinv FROM TABLE @it_list.

    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE DATA(lv_erdat) TIME DATA(lv_erzet).
    zcl_etr_regulative_log=>create( it_logs = VALUE #( FOR ls_list IN it_list ( docui = ls_list-docui
                                                                                uname = sy-uname
                                                                                datum = lv_erdat
                                                                                uzeit = lv_erzet
                                                                                logcd = zcl_etr_regulative_log=>mc_log_codes-received ) ) ).

    zcl_etr_regulative_archive=>create( it_archives = VALUE #( FOR ls_list IN it_list ( docui = ls_list-docui
                                                                                     conty = zcl_etr_regulative_archive=>mc_content_types-pdf
                                                                                     docty = 'INCINVDOC' )
                                                                                   ( docui = ls_list-docui
                                                                                    conty = zcl_etr_regulative_archive=>mc_content_types-html
                                                                                    docty = 'INCINVDOC' )
                                                                                  ( docui = ls_list-docui
                                                                                    conty = zcl_etr_regulative_archive=>mc_content_types-ubl
                                                                                    docty = 'INCINVDOC' ) ) ).
    COMMIT WORK AND WAIT.
  ENDMETHOD.