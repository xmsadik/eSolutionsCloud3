CLASS lhc_zetr_ddl_i_created_ledger DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CreatedLedger RESULT result.

    METHODS create_ledger FOR MODIFY
      IMPORTING keys FOR ACTION CreatedLedger~create_ledger.

ENDCLASS.

CLASS lhc_zetr_ddl_i_created_ledger IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create_ledger.
  ENDMETHOD.

ENDCLASS.