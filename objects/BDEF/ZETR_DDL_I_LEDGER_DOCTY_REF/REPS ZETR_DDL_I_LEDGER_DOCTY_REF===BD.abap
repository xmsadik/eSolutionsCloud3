managed implementation in class zbp_etr_ddl_i_ledger_docty_ref unique;
strict ( 2 );

define behavior for zetr_ddl_i_ledger_docty_ref //alias <alias_name>
persistent table zetr_t_blryb
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode, DocType;
  mapping for zetr_t_blryb
    {
      CompanyCode = bukrs;
      DocType     = blart;
    }
}