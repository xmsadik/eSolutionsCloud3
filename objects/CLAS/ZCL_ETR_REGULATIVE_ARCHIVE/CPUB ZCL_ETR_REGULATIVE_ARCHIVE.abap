CLASS zcl_etr_regulative_archive DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES mty_archives TYPE STANDARD TABLE OF zetr_s_document_archive WITH EMPTY KEY.

    CONSTANTS:
      BEGIN OF mc_content_types.
    CONSTANTS pdf  TYPE zetr_e_dctyp VALUE 'PDF' ##NO_TEXT.
    CONSTANTS ubl  TYPE zetr_e_dctyp VALUE 'UBL' ##NO_TEXT.
    CONSTANTS html TYPE zetr_e_dctyp VALUE 'HTML' ##NO_TEXT.
    CONSTANTS END OF mc_content_types .

    CLASS-METHODS create
      IMPORTING
        !it_archives TYPE mty_archives.
