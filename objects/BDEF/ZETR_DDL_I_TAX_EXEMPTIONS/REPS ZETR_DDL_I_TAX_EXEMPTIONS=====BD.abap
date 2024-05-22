managed implementation in class zbp_etr_ddl_i_tax_exemptions unique;
strict ( 2 );

define behavior for zetr_ddl_i_tax_exemptions //alias <alias_name>
//persistent table <???>
with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) ExemptionCode;
}