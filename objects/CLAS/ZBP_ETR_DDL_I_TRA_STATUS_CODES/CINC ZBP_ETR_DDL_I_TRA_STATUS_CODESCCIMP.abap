CLASS lhc_zetr_ddl_i_tra_status_code DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_tra_status_codes RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_tra_status_code IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_tra_status_code DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_tra_status_code IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_main TYPE TABLE OF zetr_t_rasta,
          lt_text TYPE TABLE OF zetr_t_rastx,
          lt_dele TYPE RANGE OF zetr_e_radsc.

    IF create-zetr_ddl_i_tra_status_codes IS NOT INITIAL.
      SELECT *
        FROM zetr_ddl_i_tra_status_codes
        FOR ALL ENTRIES IN @create-zetr_ddl_i_tra_status_codes
        WHERE statuscode = @create-zetr_ddl_i_tra_status_codes-statuscode
        INTO TABLE @DATA(lt_existing_codes).
    ENDIF.
    IF update-zetr_ddl_i_tra_status_codes IS NOT INITIAL.
      SELECT *
        FROM zetr_ddl_i_tra_status_codes
        FOR ALL ENTRIES IN @update-zetr_ddl_i_tra_status_codes
        WHERE statuscode = @update-zetr_ddl_i_tra_status_codes-statuscode
        APPENDING TABLE @lt_existing_codes.
    ENDIF.
    SORT lt_existing_codes BY statuscode.

    LOOP AT create-zetr_ddl_i_tra_status_codes INTO DATA(ls_create).
      IF line_exists( lt_existing_codes[ statuscode = ls_create-statuscode ] ).
        APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '200'
                                            severity = if_abap_behv_message=>severity-success
                                            v1       = ls_create-statuscode ) ) TO reported-zetr_ddl_i_tra_status_codes.
      ELSE.
        APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
        <ls_main>-radsc = ls_create-statuscode.
        <ls_main>-rsend = ls_create-resendable.
        <ls_main>-rvrse = ls_create-reversable.
        <ls_main>-succs = ls_create-success.

        APPEND INITIAL LINE TO lt_text ASSIGNING FIELD-SYMBOL(<ls_text>).
        <ls_text>-spras = sy-langu.
        <ls_text>-radsc = ls_create-statuscode.
        <ls_text>-bezei = ls_create-description.
      ENDIF.
    ENDLOOP.

    LOOP AT update-zetr_ddl_i_tra_status_codes INTO DATA(ls_update).
      READ TABLE lt_existing_codes INTO DATA(ls_existing_code) WITH KEY statuscode = ls_update-statuscode BINARY SEARCH.
      CHECK sy-subrc = 0.

      IF ls_update-%control-resendable = if_abap_behv=>mk-on OR
         ls_update-%control-reversable = if_abap_behv=>mk-on OR
         ls_update-%control-success = if_abap_behv=>mk-on.
        APPEND INITIAL LINE TO lt_main ASSIGNING <ls_main>.
        <ls_main>-radsc = ls_update-statuscode.
        CASE ls_update-%control-resendable.
          WHEN if_abap_behv=>mk-on.
            <ls_main>-rsend = ls_update-resendable.
          WHEN OTHERS.
            <ls_main>-rsend = ls_existing_code-resendable.
        ENDCASE.
        CASE ls_update-%control-reversable.
          WHEN if_abap_behv=>mk-on.
            <ls_main>-rvrse = ls_update-reversable.
          WHEN OTHERS.
            <ls_main>-rvrse = ls_existing_code-reversable.
        ENDCASE.
        CASE ls_update-%control-success.
          WHEN if_abap_behv=>mk-on.
            <ls_main>-succs = ls_update-success.
          WHEN OTHERS.
            <ls_main>-succs = ls_existing_code-success.
        ENDCASE.
      ENDIF.

      CHECK ls_update-%control-description = if_abap_behv=>mk-on.
      APPEND INITIAL LINE TO lt_text ASSIGNING <ls_text>.
      <ls_text>-spras = sy-langu.
      <ls_text>-radsc = ls_update-statuscode.
      <ls_text>-bezei = ls_update-description.
    ENDLOOP.

    LOOP AT delete-zetr_ddl_i_tra_status_codes INTO DATA(ls_delete).
      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
      <ls_dele>-low = ls_delete-statuscode.
      <ls_dele>-sign = 'I'.
      <ls_dele>-option = 'EQ'.
    ENDLOOP.

    IF lt_dele IS NOT INITIAL.
      DELETE FROM zetr_t_rasta WHERE radsc IN @lt_dele.
      DELETE FROM zetr_t_rastx WHERE radsc IN @lt_dele.
    ENDIF.
    IF lt_main IS NOT INITIAL.
      MODIFY zetr_t_rasta FROM TABLE @lt_main.
    ENDIF.
    IF lt_text IS NOT INITIAL.
      MODIFY zetr_t_rastx FROM TABLE @lt_text.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.