managed implementation in class zbp_etr_ddl_i_finance_accounts unique;
strict ( 2 );

define behavior for zetr_ddl_i_finance_accounts //alias <alias_name>
persistent table zetr_t_fiacc
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_fiacc
    {
      ChartOfAccounts = ktopl;
      GLAccount       = saknr;
      AccountType     = accty;
      TaxType         = taxty;
    }
  field ( readonly : update ) GLAccount, ChartOfAccounts;
  create;
  update;
  delete;
}