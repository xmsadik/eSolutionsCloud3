CLASS lhc_ZETR_DDL_I_DOWNLOAD_INCDLV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_download_incdlv RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_i_download_incdlv RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zetr_ddl_i_download_incdlv.

ENDCLASS.

CLASS lhc_ZETR_DDL_I_DOWNLOAD_INCDLV IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZETR_DDL_I_DOWNLOAD_INCDLV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZETR_DDL_I_DOWNLOAD_INCDLV IMPLEMENTATION.

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