CLASS lhc_ZETR_DDL_I_LEDGER_ACC_MAIN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_acc_maint RESULT result.

ENDCLASS.

CLASS lhc_ZETR_DDL_I_LEDGER_ACC_MAIN IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.