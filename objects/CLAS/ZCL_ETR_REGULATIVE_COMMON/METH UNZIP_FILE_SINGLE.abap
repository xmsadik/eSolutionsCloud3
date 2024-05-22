  METHOD unzip_file_single.
    DATA: lo_zip           TYPE REF TO cl_abap_zip,
          lv_input_xstring TYPE xstring,
          ls_file          TYPE cl_abap_zip=>t_file,
          lv_file_name     TYPE string.

    IF iv_zipped_file_xstr IS NOT INITIAL.
      lv_input_xstring = iv_zipped_file_xstr.
    ELSE.
      lv_input_xstring = cl_abap_conv_codepage=>create_out( )->convert( source = iv_zipped_file_str ).
    ENDIF.
    CREATE OBJECT lo_zip.
    lo_zip->load(
      EXPORTING
        zip             = lv_input_xstring
      EXCEPTIONS
        zip_parse_error = 1
        OTHERS          = 2 ).
    CHECK sy-subrc IS INITIAL.

    READ TABLE lo_zip->files INTO ls_file INDEX 1.
    CHECK sy-subrc IS INITIAL.

    lv_file_name = ls_file-name.
    lo_zip->get(
      EXPORTING
        name                    = lv_file_name
      IMPORTING
        content                 = ev_output_data_xstr
      EXCEPTIONS
        zip_index_error         = 1
        zip_decompression_error = 2
        OTHERS                  = 3 ).
    IF ev_output_data_str IS REQUESTED.
      ev_output_data_str = cl_abap_conv_codepage=>create_in( )->convert( source = ev_output_data_xstr ).
    ENDIF.
  ENDMETHOD.