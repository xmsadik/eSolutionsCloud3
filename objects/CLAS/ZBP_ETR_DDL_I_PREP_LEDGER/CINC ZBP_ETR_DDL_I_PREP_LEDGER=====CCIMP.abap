CLASS lhc_zetr_ddl_i_prep_ledger DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_prep_ledger RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_prep_ledger RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zetr_ddl_i_prep_ledger.

    METHODS rba_prepledgerdetail FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_prep_ledger\_prepledgerdetail FULL result_requested RESULT result LINK association_links.

    METHODS rba_setpartledger FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_prep_ledger\_setpartledger FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zetr_ddl_i_prep_ledger IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_prepledgerdetail.
  ENDMETHOD.

  METHOD rba_setpartledger.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zetr_ddl_i_prep_ledger_det DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_prep_ledger_detail RESULT result.

    METHODS rba_prepledger FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_prep_ledger_detail\_prepledger FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zetr_ddl_i_prep_ledger_det IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_prepledger.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zetr_ddl_i_setpart_ledger DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_setpart_ledger RESULT result.

    METHODS rba_prepledger FOR READ
      IMPORTING keys_rba FOR READ zetr_ddl_i_setpart_ledger\_prepledger FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zetr_ddl_i_setpart_ledger IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_prepledger.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_prep_ledger DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_prep_ledger IMPLEMENTATION.

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