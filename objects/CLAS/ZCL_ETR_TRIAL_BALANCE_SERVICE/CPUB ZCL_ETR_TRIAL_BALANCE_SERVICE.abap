CLASS zcl_etr_trial_balance_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA:  mt_users        TYPE TABLE OF zinf_users.

    CLASS-METHODS :
      trigger_trial_balance_service IMPORTING VALUE(iv_company_code) TYPE bukrs
                                              VALUE(iv_ledger)       TYPE fins_ledger
                                              VALUE(iv_gjahr)        TYPE gjahr
                                              VALUE(iv_monat)        TYPE monat
                                    RETURNING VALUE(rs_balance)      TYPE zetr_s_trial_balance,


      get_service_info.
