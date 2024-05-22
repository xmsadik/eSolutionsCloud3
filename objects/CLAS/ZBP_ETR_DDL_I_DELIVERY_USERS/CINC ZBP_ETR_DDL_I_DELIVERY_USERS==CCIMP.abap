CLASS lhc_zetr_ddl_i_delivery_users DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_delivery_users RESULT result.

    METHODS modify_list FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_delivery_users~modify_list.

ENDCLASS.

CLASS lhc_zetr_ddl_i_delivery_users IMPLEMENTATION.

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
          DATA(lo_delivery_operations) = zcl_etr_delivery_operations=>factory( iv_company = ls_key-%param-companycode ).
          DATA(lt_data) = lo_delivery_operations->update_edelivery_users( iv_db_write = abap_false ).
          DATA lt_old_data TYPE TABLE FOR DELETE zetr_ddl_i_delivery_users.
          SELECT *
            FROM zetr_ddl_i_delivery_users
            INTO CORRESPONDING FIELDS OF TABLE @lt_old_data.
          MODIFY ENTITIES OF zetr_ddl_i_delivery_users
            IN LOCAL MODE ENTITY zetr_ddl_i_delivery_users
            DELETE FROM lt_old_data.
          MODIFY ENTITIES OF zetr_ddl_i_delivery_users
            IN LOCAL MODE ENTITY zetr_ddl_i_delivery_users
            CREATE FIELDS ( TaxID RecordNo Aliass Title RegisterDate RegisterTime DefaultAlias TaxpayerType )
              WITH VALUE #( FOR ls_data IN lt_data ( %cid = ls_data-taxid && ls_data-recno
                                                     TaxID = ls_data-taxid
                                                     RecordNo = ls_data-recno
                                                     Aliass = ls_data-aliass
                                                     Title = ls_data-title
                                                     RegisterDate = ls_data-regdt
                                                     RegisterTime = ls_data-regtm
                                                     DefaultAlias = ls_data-defal
                                                     TaxpayerType = ls_data-txpty ) ).
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '000'
                                              severity = if_abap_behv_message=>severity-success
                                              v1       = 'Kaydedildi' ) ) TO reported-zetr_ddl_i_delivery_users.
        CATCH zcx_etr_regulative_exception INTO DATA(lx_regulative_exception).
          APPEND VALUE #( %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = lx_regulative_exception->get_text( ) ) ) TO reported-zetr_ddl_i_delivery_users.
      ENDTRY.
    ELSE.
      APPEND VALUE #( %msg = new_message(
                               id       = 'ZETR_COMMON'
                               number   = '001'
                               severity = if_abap_behv_message=>severity-information ) ) TO reported-zetr_ddl_i_delivery_users.
    ENDIF.
  ENDMETHOD.

ENDCLASS.