CLASS zcl_etr_tra_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS:
      generate_unit_codes,
      generate_transport_codes,
      generate_status_codes,
      generate_tax_codes,
      generate_tax_exemption_codes,
      generate_essential_partners.
