managed implementation in class zbp_etr_ddl_i_l_refl_doc unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_REFL_DOC //alias <alias_name>
persistent table zetr_t_bldbk
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) CompanyCode, DocStatu;

  mapping for zetr_t_bldbk
    {
      CompanyCode = bukrs;
      DocStatu    = bstat;
    }

}