  METHOD if_oo_adt_classrun~main.
    generate_unit_codes( ).
    out->write( 'Unit codes generated' ).
    generate_transport_codes( ).
    out->write( 'Transport codes generated' ).
    generate_status_codes( ).
    out->write( 'Status codes generated' ).
    generate_tax_codes( ).
    out->write( 'Tax codes generated' ).
    generate_tax_exemption_codes( ).
    out->write( 'Tax Exemption codes generated' ).
    generate_essential_partners( ).
    out->write( 'Partners generated' ).
  ENDMETHOD.