  METHOD outgoing_delivery_save_manu.
    IF is_header_data-bukrs IS INITIAL OR is_header_data-bldat IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e209(zetr_common).
    ELSEIF is_header_data-partner IS INITIAL AND is_header_data-werks IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e210(zetr_common).
    ELSEIF is_header_data-partner IS INITIAL AND ( is_header_data-werks IS INITIAL OR
                                                   is_header_data-lgort IS INITIAL OR
                                                   is_header_data-umwrk IS INITIAL OR
                                                   is_header_data-umlgo IS INITIAL ).
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e211(zetr_common).
    ENDIF.

    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE datum,
             defal  TYPE abap_boolean,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_dlprf,
           END OF ty_company.
    DATA: ls_company_data  TYPE ty_company,
          lt_taxpayer      TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer      TYPE ty_taxpayer,
          ls_document      TYPE zetr_t_ogdlv,
          ls_edrule_input  TYPE zetr_s_delivery_rules_in,
          ls_edrule_output TYPE zetr_s_delivery_rules_out,
          lv_number        TYPE cl_numberrange_runtime=>nr_number.

    TRY.
        SELECT SINGLE datab, datbi, genid, prfid
          FROM zetr_t_edpar
          WHERE bukrs = @is_header_data-bukrs
          INTO @ls_company_data.
        CHECK sy-subrc = 0 AND is_header_data-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

        ls_document-werks = is_header_data-werks.
        ls_document-lgort = is_header_data-lgort.
        ls_document-umwrk = is_header_data-umwrk.
        ls_document-umlgo = is_header_data-umlgo.
        IF is_header_data-partner IS NOT INITIAL.
          DATA(ls_partner_data) = get_partner_register_data( iv_partner = is_header_data-partner ).
          ls_document-taxid = ls_partner_data-bptaxnumber.
          ls_document-partner = ls_partner_data-businesspartner.
        ENDIF.

        ls_document-bldat = is_header_data-bldat.
        ls_document-ernam = sy-uname.
        ls_document-erdat = cl_abap_context_info=>get_system_date( ).
        ls_document-erzet = cl_abap_context_info=>get_system_time( ).

        ls_edrule_input-awtyp = 'MANU'.
        ls_edrule_input-partner = ls_document-partner.
        ls_edrule_input-werks = ls_document-werks.
        ls_edrule_input-lgort = ls_document-lgort.
        ls_edrule_input-umwrk = ls_document-umwrk.
        ls_edrule_input-umlgo = ls_document-umlgo.
        ls_edrule_input-sobkz = ls_document-sobkz.
        ls_edrule_input-bwart = ls_document-bwart.

        CLEAR ls_edrule_output.
        ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'P'
                                               is_rule_input  = ls_edrule_input ).
        CHECK ls_edrule_output IS NOT INITIAL AND ls_edrule_output-excld IS INITIAL.
        IF ls_edrule_output-pidou IS INITIAL.
          ls_edrule_output-pidou = 'TEMEL'.
        ENDIF.
        IF ls_edrule_output-dtyou IS INITIAL.
          ls_edrule_output-dtyou = 'SEVK'.
        ENDIF.
        ls_document-prfid = ls_edrule_output-pidou.
        ls_document-dlvty = ls_edrule_output-dtyou.

        IF ls_document-partner IS INITIAL.
          ls_document-taxid = mv_company_taxid.
        ENDIF.

        IF ls_document-taxid IS NOT INITIAL.
          " check if partner is registered
          SELECT aliass, regdt, defal
            FROM zetr_t_dlv_ruser
            WHERE taxid = @ls_document-taxid
              AND regdt <= @ls_document-bldat
            INTO TABLE @lt_taxpayer.
          IF sy-subrc = 0.
            SORT lt_taxpayer BY defal.
            READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
            IF sy-subrc = 0.
              ls_document-aliass = ls_taxpayer-aliass.
            ELSE.
              SORT lt_taxpayer DESCENDING BY regdt.
              READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
              IF sy-subrc EQ 0.
                ls_document-aliass = ls_taxpayer-aliass.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-dlvui = cl_system_uuid=>create_uuid_c36_static( ).

        ls_document-bukrs = is_header_data-bukrs.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = 'ZETR_MDN'
            quantity          = 1
          IMPORTING
            number            = lv_number ).
        ls_document-belnr = lv_number+10(10).
        ls_document-gjahr = is_header_data-bldat(4).
        ls_document-awtyp = 'MANU'.

        ls_edrule_input-dtyin = ls_document-dlvty.
        ls_edrule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_edrule_output.
          ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'S'
                                                 is_rule_input  = ls_edrule_input ).
          IF ls_edrule_output IS NOT INITIAL.
            ls_document-serpr = ls_edrule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM zetr_t_edser
              WHERE bukrs = @is_header_data-bukrs
                AND maisp = @abap_true
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_edrule_output.
        ls_edrule_output = get_edelivery_rule( iv_rule_type   = 'X'
                                               is_rule_input  = ls_edrule_input ).
        IF ls_edrule_output IS NOT INITIAL.
          ls_document-xsltt = ls_edrule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_edxslt
            WHERE bukrs = @is_header_data-bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
        es_document = ls_document.

        CHECK es_document IS NOT INITIAL.
        INSERT zetr_t_ogdlv FROM @es_document.
        DATA lt_contents TYPE TABLE OF zetr_t_arcd.
        lt_contents = VALUE #( ( docty = 'OUTDLVDOC'
                                 docui = es_document-docui
                                 conty = 'PDF' )
                               ( docty = 'OUTDLVDOC'
                                 docui = es_document-docui
                                 conty = 'HTML' )
                               ( docty = 'OUTDLVDOC'
                                 docui = es_document-docui
                                 conty = 'UBL' ) ).
        INSERT zetr_t_arcd FROM TABLE @lt_contents.
        DATA(ls_transport) = CORRESPONDING zetr_t_odth( es_document EXCEPT taxid ).
        INSERT zetr_t_odth FROM @ls_transport.
*    INSERT zetr_t_ogdli FROM TABLE @lt_items.
        zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-created
                                                   iv_document_id = es_document-docui ).
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_error) = CONV bapi_msg( lx_root->get_text( ) ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e000(zetr_common) WITH lv_error(50) lv_error+50(50) lv_error+100(50) lv_error+150(50).
    ENDTRY.
  ENDMETHOD.