CLASS lhc_zetr_ddl_i_invoice_users DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_invoice_users RESULT result.
    METHODS modify_list FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_invoice_users~modify_list.

ENDCLASS.

CLASS lhc_zetr_ddl_i_invoice_users IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD modify_list.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0.
    SELECT SINGLE @abap_true
      FROM zetr_t_cmpin
      WHERE bukrs = @ls_key-%param-CompanyCode
      INTO @DATA(lv_exists).
    IF lv_exists = abap_true.
      TRY.
          DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( iv_company = ls_key-%param-companycode ).
          DATA(lt_data) = lo_invoice_operations->update_einvoice_users( iv_db_write = abap_true ).
*          DATA lt_old_data TYPE TABLE FOR DELETE zetr_ddl_i_invoice_users.
*          SELECT *
*            FROM zetr_ddl_i_invoice_users
*            INTO CORRESPONDING FIELDS OF TABLE @lt_old_data.
*          MODIFY ENTITIES OF zetr_ddl_i_invoice_users
*            IN LOCAL MODE ENTITY zetr_ddl_i_invoice_users
*            DELETE FROM lt_old_data.
*          DATA lt_data_temp TYPE zcl_etr_einvoice_ws=>mty_taxpayers_list .
*          LOOP AT lt_data INTO DATA(ls_data_temp).
*            APPEND ls_data_temp TO lt_data_temp.
*            IF lines( lt_data_temp ) >= 500000.
*              MODIFY ENTITIES OF zetr_ddl_i_invoice_users
*                IN LOCAL MODE ENTITY zetr_ddl_i_invoice_users
*                CREATE FIELDS ( TaxID RecordNo Aliass Title RegisterDate RegisterTime DefaultAlias TaxpayerType )
*                  WITH VALUE #( FOR ls_data IN lt_data_temp ( %cid = ls_data-taxid && ls_data-recno
*                                                         TaxID = ls_data-taxid
*                                                         RecordNo = ls_data-recno
*                                                         Aliass = ls_data-aliass
*                                                         Title = ls_data-title
*                                                         RegisterDate = ls_data-regdt
*                                                         RegisterTime = ls_data-regtm
*                                                         DefaultAlias = ls_data-defal
*                                                         TaxpayerType = ls_data-txpty ) ).
*              CLEAR lt_data_temp.
*            ENDIF.
*          ENDLOOP.
*          IF lt_data_temp IS NOT INITIAL.
*            MODIFY ENTITIES OF zetr_ddl_i_invoice_users
*             IN LOCAL MODE ENTITY zetr_ddl_i_invoice_users
*             CREATE FIELDS ( TaxID RecordNo Aliass Title RegisterDate RegisterTime DefaultAlias TaxpayerType )
*               WITH VALUE #( FOR ls_data IN lt_data_temp ( %cid = ls_data-taxid && ls_data-recno
*                                                           TaxID = ls_data-taxid
*                                                           RecordNo = ls_data-recno
*                                                           Aliass = ls_data-aliass
*                                                           Title = ls_data-title
*                                                           RegisterDate = ls_data-regdt
*                                                           RegisterTime = ls_data-regtm
*                                                           DefaultAlias = ls_data-defal
*                                                           TaxpayerType = ls_data-txpty ) ).
*          ENDIF.
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '082'
                                              severity = if_abap_behv_message=>severity-success ) ) TO reported-zetr_ddl_i_invoice_users.
        CATCH zcx_etr_regulative_exception INTO DATA(lx_regulative_exception).
          APPEND VALUE #( %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = lx_regulative_exception->get_text( ) ) ) TO reported-zetr_ddl_i_invoice_users.
      ENDTRY.
    ELSE.
      APPEND VALUE #( %msg = new_message(
                               id       = 'ZETR_COMMON'
                               number   = '001'
                               severity = if_abap_behv_message=>severity-information ) ) TO reported-zetr_ddl_i_invoice_users.
    ENDIF.
  ENDMETHOD.

ENDCLASS.