CLASS lhc_zetr_ddl_i_ledger_refl_doc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_refl_doc RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_ledger_refl_doc IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.