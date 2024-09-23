CLASS lhc_zetr_ddl_i_ledger_tradoc_t DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_tradoc_types RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_ledger_tradoc_t IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.