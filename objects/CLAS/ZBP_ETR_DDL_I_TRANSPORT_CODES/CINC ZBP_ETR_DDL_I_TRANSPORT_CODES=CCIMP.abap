CLASS lhc_zetr_ddl_i_transport_codes DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_transport_codes RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_transport_codes IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_transport_codes DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_transport_codes IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_main TYPE TABLE OF zetr_t_trnsp,
          lt_text TYPE TABLE OF zetr_t_trnsx,
          lt_dele TYPE RANGE OF zetr_e_trnsp.

    IF create-zetr_ddl_i_transport_codes IS NOT INITIAL.
      SELECT trnsp
        FROM zetr_t_trnsp
        FOR ALL ENTRIES IN @create-zetr_ddl_i_transport_codes
        WHERE trnsp = @create-zetr_ddl_i_transport_codes-transportcode
        INTO TABLE @DATA(lt_existing_codes).
      SORT lt_existing_codes BY trnsp.
    ENDIF.

    LOOP AT create-zetr_ddl_i_transport_codes INTO DATA(ls_create).
      IF line_exists( lt_existing_codes[ trnsp = ls_create-transportcode ] ).
        APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '200'
                                            severity = if_abap_behv_message=>severity-success
                                            v1       = ls_create-transportcode ) ) TO reported-zetr_ddl_i_transport_codes.
      ELSE.
        APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
        <ls_main>-trnsp = ls_create-transportcode.

        APPEND INITIAL LINE TO lt_text ASSIGNING FIELD-SYMBOL(<ls_text>).
        <ls_text>-spras = sy-langu.
        <ls_text>-trnsp = ls_create-transportcode.
        <ls_text>-bezei = ls_create-description.
      ENDIF.
    ENDLOOP.

    LOOP AT update-zetr_ddl_i_transport_codes INTO DATA(ls_update).
      APPEND INITIAL LINE TO lt_text ASSIGNING <ls_text>.
      <ls_text>-spras = sy-langu.
      <ls_text>-trnsp = ls_update-transportcode.
      <ls_text>-bezei = ls_update-description.
    ENDLOOP.

    LOOP AT delete-zetr_ddl_i_transport_codes INTO DATA(ls_delete).
      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
      <ls_dele>-low = ls_delete-transportcode.
      <ls_dele>-sign = 'I'.
      <ls_dele>-option = 'EQ'.
    ENDLOOP.

    IF lt_dele IS NOT INITIAL.
      DELETE FROM zetr_t_trnsp WHERE trnsp IN @lt_dele.
      DELETE FROM zetr_t_trnsx WHERE trnsp IN @lt_dele.
    ENDIF.
    IF lt_main IS NOT INITIAL.
      INSERT zetr_t_trnsp FROM TABLE @lt_main.
    ENDIF.
    IF lt_text IS NOT INITIAL.
      MODIFY zetr_t_trnsx FROM TABLE @lt_text.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.