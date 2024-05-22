  METHOD get_partner_register_data.
    IF iv_customer IS NOT INITIAL.
      SELECT  customer~businesspartner, tax~bptaxnumber, register~aliass, register~regdt AS registerdate, register~title
        FROM i_businesspartnercustomer AS customer
        LEFT OUTER JOIN i_businesspartnertaxnumber AS tax
          ON tax~businesspartner = customer~businesspartner
          AND ( tax~bptaxtype = 'TR2' OR tax~bptaxtype = 'TR3' )
        LEFT OUTER JOIN zetr_t_inv_ruser AS register
          ON register~taxid = tax~bptaxnumber
        WHERE customer~customer = @iv_customer
        ORDER BY register~defal DESCENDING
        INTO @rs_data.
      ENDSELECT.
    ELSEIF iv_supplier IS NOT INITIAL.
      SELECT  supplier~businesspartner, tax~bptaxnumber, register~aliass, register~regdt AS registerdate, register~title
        FROM i_businesspartnersupplier AS supplier
        LEFT OUTER JOIN i_businesspartnertaxnumber AS tax
          ON tax~businesspartner = supplier~businesspartner
          AND ( tax~bptaxtype = 'TR2' OR tax~bptaxtype = 'TR3' )
        LEFT OUTER JOIN zetr_t_inv_ruser AS register
          ON register~taxid = tax~bptaxnumber
        WHERE supplier~supplier = @iv_supplier
        ORDER BY register~defal DESCENDING
        INTO @rs_data.
      ENDSELECT.
    ELSEIF iv_partner IS NOT INITIAL.
      SELECT  partner~businesspartner, tax~bptaxnumber, register~aliass, register~regdt AS registerdate, register~title
        FROM i_businesspartner AS partner
        LEFT OUTER JOIN i_businesspartnertaxnumber AS tax
          ON tax~businesspartner = partner~businesspartner
          AND ( tax~bptaxtype = 'TR2' OR tax~bptaxtype = 'TR3' )
        LEFT OUTER JOIN zetr_t_inv_ruser AS register
          ON register~taxid = tax~bptaxnumber
        WHERE partner~businesspartner = @iv_partner
        ORDER BY register~defal DESCENDING
        INTO @rs_data.
      ENDSELECT.
    ENDIF.
  ENDMETHOD.