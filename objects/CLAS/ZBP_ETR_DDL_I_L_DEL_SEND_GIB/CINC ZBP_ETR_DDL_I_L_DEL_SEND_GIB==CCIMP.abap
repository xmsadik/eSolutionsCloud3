CLASS lhc_zetr_ddl_i_ledger_del_send DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_ledger_del_send_gib RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_ledger_del_send IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_ledger_del_send DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.


    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_ledger_del_send IMPLEMENTATION.


  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.