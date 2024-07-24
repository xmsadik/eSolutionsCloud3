managed implementation in class zbp_etr_ddl_i_l_del_send_gib unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_DEL_SEND_GIB //alias <alias_name>
persistent table zetr_t_ggbsl
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) BranchCode, CompanyCode, FiscalMonth, FiscalYear;

  mapping for zetr_t_ggbsl
    {
      CompanyCode = bukrs;
      BranchCode  = bcode;
      FiscalYear  = gjahr;
      FiscalMonth = monat;
    }

}