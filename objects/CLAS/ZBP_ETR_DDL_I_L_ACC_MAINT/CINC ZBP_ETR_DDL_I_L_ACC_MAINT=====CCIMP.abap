CLASS lhc_zetr_ddl_i_ledger_acc_main DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_acc_maint RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_ledger_acc_main IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.