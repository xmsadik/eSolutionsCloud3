CLASS lhc_zetr_ddl_i_ledger_company_ DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_company_info RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_ledger_company_ IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations