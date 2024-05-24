  METHOD create.
    DATA: lt_archive  TYPE TABLE OF zetr_t_arcd.
*          ls_archive  TYPE zetr_t_arcd,
*          lt_archives TYPE mty_archives,
*          ls_archives TYPE zetr_s_document_archive.
*    lt_archives = it_archives.
*
*    LOOP AT lt_archives INTO ls_archives.
*      MOVE-CORRESPONDING ls_archives TO ls_archive.
**      TRY.
**          ls_archive-arcid = cl_system_uuid=>create_uuid_c22_static( ).
**        CATCH cx_uuid_error.
**          "handle exception
**      ENDTRY.
*      APPEND ls_archive TO lt_archive.
*      CLEAR ls_archive.
*    ENDLOOP.
    lt_archive = CORRESPONDING #( it_archives ).
    CHECK lt_archive IS NOT INITIAL.
    INSERT zetr_t_arcd FROM TABLE @lt_archive.
  ENDMETHOD.