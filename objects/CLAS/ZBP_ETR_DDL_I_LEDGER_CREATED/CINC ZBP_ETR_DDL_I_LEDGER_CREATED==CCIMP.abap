CLASS lhc_CreatedLedger DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CreatedLedgers RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ CreatedLedgers RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK CreatedLedgers.

    METHODS rba_Ledgerparts FOR READ
      IMPORTING keys_rba FOR READ CreatedLedgers\_Ledgerparts FULL result_requested RESULT result LINK association_links.

    METHODS rba_Ledgertotals FOR READ
      IMPORTING keys_rba FOR READ CreatedLedgers\_Ledgertotals FULL result_requested RESULT result LINK association_links.

    METHODS create_ledger FOR MODIFY
      IMPORTING keys FOR ACTION CreatedLedgers~create_ledger.

ENDCLASS.

CLASS lhc_CreatedLedger IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Ledgerparts.
  ENDMETHOD.

  METHOD rba_Ledgertotals.
  ENDMETHOD.

  METHOD create_ledger.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_LedgerParts DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ LedgerParts RESULT result.

    METHODS rba_Createdledger FOR READ
      IMPORTING keys_rba FOR READ LedgerParts\_Createdledger FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_LedgerParts IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Createdledger.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_LedgerTotals DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ LedgerTotals RESULT result.

    METHODS rba_Createdledger FOR READ
      IMPORTING keys_rba FOR READ LedgerTotals\_Createdledger FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_LedgerTotals IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Createdledger.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZETR_DDL_I_LEDGER_CREATED DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZETR_DDL_I_LEDGER_CREATED IMPLEMENTATION.

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