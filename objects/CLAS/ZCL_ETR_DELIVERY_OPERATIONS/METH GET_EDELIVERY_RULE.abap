  METHOD get_edelivery_rule.
    DATA: lt_awtyp   TYPE RANGE OF zetr_e_awtyp,
          lt_vkorg   TYPE RANGE OF zetr_e_vkorg,
          lt_vtweg   TYPE RANGE OF zetr_e_vtweg,
          lt_werks   TYPE RANGE OF werks_d,
          lt_lgort   TYPE RANGE OF le_shp_stor_loc,
          lt_umwrk   TYPE RANGE OF zetr_e_umwrk,
          lt_umlgo   TYPE RANGE OF zetr_e_umlgo,
          lt_sobkz   TYPE RANGE OF sobkz,
          lt_bwart   TYPE RANGE OF bwart,
          lt_dlvty   TYPE RANGE OF zetr_e_dlvty,
          lt_sddty   TYPE RANGE OF zetr_e_fkart,
          lt_mmdty   TYPE RANGE OF blart,
          lt_fidty   TYPE RANGE OF blart,
          lt_prfid   TYPE RANGE OF zetr_e_dlprf,
          lt_partner TYPE RANGE OF zetr_e_partner,
          ls_rule    TYPE zetr_t_edrules.

    lt_awtyp   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-awtyp   ) ).
    lt_vkorg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vkorg   ) ).
    lt_vtweg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vtweg   ) ).
    lt_werks   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-werks   ) ).
    lt_lgort   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-lgort   ) ).
    lt_umwrk   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-umwrk   ) ).
    lt_umlgo   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-umlgo   ) ).
    lt_sobkz   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-sobkz   ) ).
    lt_bwart   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-bwart   ) ).
    lt_dlvty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-dtyin   ) ).
    lt_sddty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-sddty   ) ).
    lt_mmdty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-mmdty   ) ).
    lt_fidty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-fidty   ) ).
    lt_prfid   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-pidin   ) ).
    lt_partner = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-partner   ) ).

    SORT: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_lgort, lt_umwrk, lt_umlgo, lt_sobkz, lt_bwart, lt_dlvty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid.
    DELETE ADJACENT DUPLICATES FROM: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_lgort, lt_umwrk, lt_umlgo, lt_sobkz, lt_bwart, lt_dlvty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid.

    SELECT *
      FROM zetr_t_edrules
      WHERE bukrs EQ @mv_company_code
        AND rulet EQ @iv_rule_type
        AND awtyp IN @lt_awtyp
        AND vkorg IN @lt_vkorg
        AND vtweg IN @lt_vtweg
        AND werks IN @lt_werks
        AND lgort IN @lt_lgort
        AND umwrk IN @lt_umwrk
        AND umlgo IN @lt_umlgo
        AND sobkz IN @lt_sobkz
        AND bwart IN @lt_bwart
        AND dtyin IN @lt_dlvty
        AND sddty IN @lt_sddty
        AND mmdty IN @lt_mmdty
        AND fidty IN @lt_fidty
        AND pidin IN @lt_prfid
        AND partner IN @lt_partner
      ORDER BY  awtyp   DESCENDING,
                vkorg   DESCENDING,
                vtweg   DESCENDING,
                werks   DESCENDING,
                lgort   DESCENDING,
                umwrk   DESCENDING,
                umlgo   DESCENDING,
                sobkz   DESCENDING,
                bwart   DESCENDING,
                dtyin   DESCENDING,
                sddty   DESCENDING,
                mmdty   DESCENDING,
                fidty   DESCENDING,
                pidin   DESCENDING,
                partner DESCENDING
        INTO @ls_rule.
      IF ls_rule-awtyp IS NOT INITIAL.
        CHECK ls_rule-awtyp = is_rule_input-awtyp.
      ENDIF.
      IF ls_rule-vkorg IS NOT INITIAL.
        CHECK ls_rule-vkorg = is_rule_input-vkorg.
      ENDIF.
      IF ls_rule-vtweg IS NOT INITIAL.
        CHECK ls_rule-vtweg = is_rule_input-vtweg.
      ENDIF.
      IF ls_rule-werks IS NOT INITIAL.
        CHECK ls_rule-werks = is_rule_input-werks.
      ENDIF.
      IF ls_rule-lgort IS NOT INITIAL.
        CHECK ls_rule-lgort = is_rule_input-lgort.
      ENDIF.
      IF ls_rule-umwrk IS NOT INITIAL.
        CHECK ls_rule-umwrk = is_rule_input-umwrk.
      ENDIF.
      IF ls_rule-umlgo IS NOT INITIAL.
        CHECK ls_rule-umlgo = is_rule_input-umlgo.
      ENDIF.
      IF ls_rule-sobkz IS NOT INITIAL.
        CHECK ls_rule-sobkz = is_rule_input-sobkz.
      ENDIF.
      IF ls_rule-bwart IS NOT INITIAL.
        CHECK ls_rule-bwart = is_rule_input-bwart.
      ENDIF.
      IF ls_rule-pidin IS NOT INITIAL.
        CHECK ls_rule-pidin = is_rule_input-pidin.
      ENDIF.
      IF ls_rule-dtyin IS NOT INITIAL.
        CHECK ls_rule-dtyin = is_rule_input-dtyin.
      ENDIF.
      IF ls_rule-sddty IS NOT INITIAL.
        CHECK ls_rule-sddty = is_rule_input-sddty.
      ENDIF.
      IF ls_rule-mmdty IS NOT INITIAL.
        CHECK ls_rule-mmdty = is_rule_input-mmdty.
      ENDIF.
      IF ls_rule-fidty IS NOT INITIAL.
        CHECK ls_rule-fidty = is_rule_input-fidty.
      ENDIF.
      IF ls_rule-partner IS NOT INITIAL.
        CHECK ls_rule-partner = is_rule_input-partner.
      ENDIF.
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      EXIT.
    ENDSELECT.
    IF sy-subrc = 0 AND iv_rule_type = 'P' AND ( rs_rule_output-pidou IS INITIAL OR rs_rule_output-dtyou IS INITIAL ).
      IF rs_rule_output-pidou IS INITIAL.
        rs_rule_output-pidou = 'TEMEL'.
      ENDIF.
      IF rs_rule_output-dtyou IS INITIAL.
        rs_rule_output-dtyou = 'SEVK'.
      ENDIF.
    ENDIF.
  ENDMETHOD.