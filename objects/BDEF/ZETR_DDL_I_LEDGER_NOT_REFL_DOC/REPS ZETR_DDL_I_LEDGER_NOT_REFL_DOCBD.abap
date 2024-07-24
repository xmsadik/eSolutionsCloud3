managed implementation in class zbp_etr_ddl_i_l_not_refl_doc unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_NOT_REFL_DOC //alias <alias_name>
persistent table zetr_t_dybel
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) CompanyCode, DocNo, FiscalYear;

  mapping for zetr_t_dybel
    {
      CompanyCode = bukrs;
      DocNo       = belnr;
      FiscalYear  = gjahr;
    }
}