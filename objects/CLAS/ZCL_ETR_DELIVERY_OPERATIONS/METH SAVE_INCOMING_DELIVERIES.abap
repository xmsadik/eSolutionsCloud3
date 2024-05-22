  METHOD save_incoming_deliveries.
    INSERT zetr_t_icdlv FROM TABLE @it_list.
    INSERT zetr_t_icdli FROM TABLE @it_items.

    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE DATA(lv_erdat) TIME DATA(lv_erzet).
    zcl_etr_regulative_log=>create( it_logs = VALUE #( FOR ls_list IN it_list ( docui = ls_list-docui
                                                                                uname = sy-uname
                                                                                datum = lv_erdat
                                                                                uzeit = lv_erzet
                                                                                logcd = zcl_etr_regulative_log=>mc_log_codes-received ) ) ).

    zcl_etr_regulative_archive=>create( it_archives = VALUE #( FOR ls_list IN it_list ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-pdf
                                                                                        docty = 'INCDLVDOC' )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-html
                                                                                        docty = 'INCDLVDOC' )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-ubl
                                                                                        docty = 'INCDLVDOC' ) ) ).

    zcl_etr_regulative_archive=>create( it_archives = VALUE #( FOR ls_list IN it_list WHERE ( ruuidc IS NOT INITIAL )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-pdf
                                                                                        docty = 'INCDLVRES' )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-html
                                                                                        docty = 'INCDLVRES' )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-ubl
                                                                                        docty = 'INCDLVRES' ) ) ).

    COMMIT WORK AND WAIT.
  ENDMETHOD.