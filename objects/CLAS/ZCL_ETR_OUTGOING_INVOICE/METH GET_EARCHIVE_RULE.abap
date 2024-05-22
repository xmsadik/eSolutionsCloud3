  METHOD get_earchive_rule.
    DATA: lt_awtyp   TYPE RANGE OF zetr_e_awtyp,
          lt_vkorg   TYPE RANGE OF zetr_e_vkorg,
          lt_vtweg   TYPE RANGE OF zetr_e_vtweg,
          lt_werks   TYPE RANGE OF werks_d,
          lt_invty   TYPE RANGE OF zetr_e_invty,
          lt_sddty   TYPE RANGE OF zetr_e_fkart,
          lt_mmdty   TYPE RANGE OF zetr_e_mmidt,
          lt_fidty   TYPE RANGE OF zetr_e_fidty,
          lt_partner TYPE RANGE OF zetr_e_partner,
          lt_prfid   TYPE RANGE OF zetr_e_inprf,
          lt_vbeln   TYPE RANGE OF sd_sls_document,
          ls_rule    TYPE zetr_t_earules.

    lt_awtyp   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-awtyp   ) ).
    lt_vkorg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vkorg   ) ).
    lt_vtweg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vtweg   ) ).
    lt_werks   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-werks   ) ).
    lt_invty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-ityin   ) ).
    lt_sddty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-sddty   ) ).
    lt_mmdty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-mmdty   ) ).
    lt_fidty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-fidty   ) ).
    lt_partner = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-partner ) ).
    lt_prfid   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-pidin   ) ).
    lt_vbeln   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vbeln   ) ).

    SORT: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid, lt_vbeln.
    DELETE ADJACENT DUPLICATES FROM: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid, lt_vbeln.

    SELECT *
      FROM zetr_t_earules
      WHERE bukrs EQ @ms_document-bukrs
        AND rulet EQ @iv_rule_type
        AND awtyp IN @lt_awtyp
        AND vkorg IN @lt_vkorg
        AND vtweg IN @lt_vtweg
        AND werks IN @lt_werks
        AND ityin IN @lt_invty
        AND sddty IN @lt_sddty
        AND mmdty IN @lt_mmdty
        AND fidty IN @lt_fidty
        AND pidin IN @lt_prfid
        AND vbeln IN @lt_vbeln
        AND partner IN @lt_partner
      ORDER BY  awtyp   DESCENDING,
                vkorg   DESCENDING,
                vtweg   DESCENDING,
                werks   DESCENDING,
                ityin   DESCENDING,
                sddty   DESCENDING,
                mmdty   DESCENDING,
                fidty   DESCENDING,
                pidin   DESCENDING,
                vbeln   DESCENDING,
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
      IF ls_rule-pidin IS NOT INITIAL.
        CHECK ls_rule-pidin = is_rule_input-pidin.
      ENDIF.
      IF ls_rule-ityin IS NOT INITIAL.
        CHECK ls_rule-ityin = is_rule_input-ityin.
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
      IF ls_rule-vbeln IS NOT INITIAL.
        CHECK ls_rule-vbeln = is_rule_input-vbeln.
      ENDIF.
      IF ls_rule-partner IS NOT INITIAL.
        CHECK ls_rule-partner = is_rule_input-partner.
      ENDIF.
      APPEND CORRESPONDING #( ls_rule ) TO rt_rule_output.
      EXIT.
    ENDSELECT.
  ENDMETHOD.