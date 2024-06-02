CLASS zcl_etr_regulative_common DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .
  PUBLIC SECTION.
    TYPES: BEGIN OF mty_xml_node,
             node_type  TYPE string,
             prefix     TYPE string,
             name       TYPE string,
             nsuri      TYPE string,
             value_type TYPE string,
             value      TYPE string,
           END OF mty_xml_node,
           mty_xml_nodes TYPE TABLE OF mty_xml_node WITH EMPTY KEY,
           mty_hash      TYPE c LENGTH 32.
    CLASS-METHODS parse_xml
      IMPORTING
        iv_xml_string  TYPE string
        iv_xml_xstring TYPE xstring OPTIONAL
      RETURNING
        VALUE(rt_data) TYPE mty_xml_nodes.
    CLASS-METHODS get_node_type
      IMPORTING
        node_type_int           TYPE i
      RETURNING
        VALUE(node_type_string) TYPE string.
    CLASS-METHODS get_value_type
      IMPORTING
        value_type_int           TYPE i
      RETURNING
        VALUE(value_type_string) TYPE string.
    CLASS-METHODS unzip_file_single
      IMPORTING
        !iv_zipped_file_str  TYPE string OPTIONAL
        !iv_zipped_file_xstr TYPE xstring OPTIONAL
      EXPORTING
        ev_output_data_str   TYPE string
        ev_output_data_xstr  TYPE xstring.
    CLASS-METHODS calculate_hash_for_raw
      IMPORTING
        !iv_raw_data              TYPE xstring
      RETURNING
        VALUE(rv_calculated_hash) TYPE string.
    CLASS-METHODS get_api_url
      RETURNING
        VALUE(rv_url) TYPE string.
    CLASS-METHODS get_ui_url
      RETURNING
        VALUE(rv_url) TYPE string.
    CLASS-METHODS amount_to_words
      IMPORTING
        !amount      TYPE wrbtr_cs
        !currency    TYPE string
      RETURNING
        VALUE(words) TYPE string.
    CLASS-METHODS number_to_words
      IMPORTING
        !number      TYPE string
      RETURNING
        VALUE(words) TYPE string.