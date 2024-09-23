CLASS lhc_zetr_ddL_i_ledger_incor_do DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddL_i_ledger_incor_docty RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddL_i_ledger_incor_do IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.