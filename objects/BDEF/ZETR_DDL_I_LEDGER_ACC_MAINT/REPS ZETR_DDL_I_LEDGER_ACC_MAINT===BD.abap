managed implementation in class zbp_etr_ddl_i_l_acc_maint unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_ACC_MAINT //alias <alias_name>
persistent table zetr_t_hesbk
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) ChartOfAcc, CompanyCode, IncExc, AccHigh, AccLow, AccOption;

  mapping for zetr_t_hesbk
    {
      CompanyCode = bukrs;
      ChartOfAcc  = ktopl;
      IncExc      = ssign;
      AccOption   = soptn;
      AccLow      = splow;
      AccHigh     = shigh;
    }
}