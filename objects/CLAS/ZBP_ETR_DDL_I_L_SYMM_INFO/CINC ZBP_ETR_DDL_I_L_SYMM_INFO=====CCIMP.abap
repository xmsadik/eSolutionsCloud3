CLASS lhc_zetr_ddl_i_ledger_symm_inf DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_symm_info RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_ledger_symm_inf IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.