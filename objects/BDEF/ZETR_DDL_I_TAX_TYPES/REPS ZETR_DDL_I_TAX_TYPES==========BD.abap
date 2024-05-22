managed implementation in class zbp_etr_ddl_i_tax_types unique;
strict ( 2 );

define behavior for ZETR_DDL_I_TAX_TYPES //alias <alias_name>
//persistent table <???>
with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field( readonly : update ) TaxType;
}