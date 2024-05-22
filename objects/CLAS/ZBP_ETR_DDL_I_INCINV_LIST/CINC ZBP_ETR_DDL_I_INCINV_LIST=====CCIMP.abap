CLASS lhc_zetr_ddl_i_incinv_list DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zetr_ddl_i_incinv_list RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_incinv_list RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zetr_ddl_i_incinv_list.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_incinv_list RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zetr_ddl_i_incinv_list.

    METHODS rba_Invoicecontents FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_incinv_list\_Invoicecontents FULL result_requested RESULT result LINK association_links.

    METHODS rba_Invoicelogs FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_incinv_list\_Invoicelogs FULL result_requested RESULT result LINK association_links.

    METHODS archiveInvoices FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_incinv_list~archiveInvoices RESULT result.

    METHODS downloadInvoices FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_incinv_list~downloadInvoices RESULT result.

    METHODS sendResponse FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_incinv_list~sendResponse RESULT result.

    METHODS statusUpdate FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_incinv_list~statusUpdate RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_incinv_list IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Invoicecontents.
  ENDMETHOD.

  METHOD rba_Invoicelogs.
  ENDMETHOD.

  METHOD archiveInvoices.
  ENDMETHOD.

  METHOD downloadInvoices.
  ENDMETHOD.

  METHOD sendResponse.
  ENDMETHOD.

  METHOD statusUpdate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zetr_ddl_i_incinv_content DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_incinv_content RESULT result.

    METHODS rba_Incominginvoices FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_incinv_content\_Incominginvoices FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zetr_ddl_i_incinv_content IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Incominginvoices.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zetr_ddl_i_incinv_logs DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_incinv_logs RESULT result.

    METHODS rba_Incominginvoices FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_incinv_logs\_Incominginvoices FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zetr_ddl_i_incinv_logs IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Incominginvoices.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZETR_DDL_I_INCINV_LIST DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZETR_DDL_I_INCINV_LIST IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.