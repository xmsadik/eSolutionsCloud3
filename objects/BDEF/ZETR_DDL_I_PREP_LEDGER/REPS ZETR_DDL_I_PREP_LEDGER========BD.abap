unmanaged implementation in class zbp_etr_ddl_i_prep_ledger unique;
strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for zetr_ddl_i_prep_ledger //alias _prepLedger
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
  association _PrepLedgerDetail;
  association _SetPartLedger;
  //  create;
  //  update;
  //  delete;

  field ( readonly ) bukrs, gjahr, monat;
}


define behavior for zetr_ddl_i_prep_ledger_detail //alias _prepLedgerDetail
//late numbering
lock dependent by _PrepLedger
authorization dependent by _PrepLedger
//etag master <field_name>
{
  //  update;
  //  delete;
  field ( readonly ) bukrs, gjahr, monat;
  association _PrepLedger;
}

define behavior for ZETR_DDL_I_setpart_ledger //alias _prepLedgerDetail
//late numbering
lock dependent by _PrepLedger
authorization dependent by _PrepLedger
//etag master <field_name>
{
  //  update;
  //  delete;
  field ( readonly ) bukrs, gjahr, monat,datbi,partn;
  association _PrepLedger;
}