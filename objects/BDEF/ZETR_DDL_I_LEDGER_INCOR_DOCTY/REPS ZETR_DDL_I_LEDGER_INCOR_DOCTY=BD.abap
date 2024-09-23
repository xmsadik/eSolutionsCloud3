managed implementation in class zbp_etr_ddl_i_ledger_incor_doc unique;
strict ( 2 );

define behavior for zetr_ddL_i_ledger_incor_docty //alias <alias_name>
persistent table zetr_t_bthbl
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode, DocNo, FiscalYear;
  mapping for zetr_t_bthbl
    {
      CompanyCode = bukrs;
      DocNo       = belnr;
      FiscalYear  = gjahr;
      DocType     = blart;
    }
}