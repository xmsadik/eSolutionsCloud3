managed implementation in class zbp_etr_ddl_i_l_acc_planning unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_ACC_PLANNING //alias <alias_name>
//late numbering
persistent table zetr_t_hespl
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) AccCode, AccPlanning;

  mapping for zetr_t_hespl
    {
      AccPlanning = ktopl;
      AccCode     = saknr;
      AccCodeDesc = saknr_t;
    }


}