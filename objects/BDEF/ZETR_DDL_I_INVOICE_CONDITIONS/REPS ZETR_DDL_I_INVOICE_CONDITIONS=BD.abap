managed implementation in class zbp_etr_ddl_i_invoice_conditio unique;
strict ( 2 );

define behavior for zetr_ddl_i_invoice_conditions //alias <alias_name>
persistent table zetr_t_inv_cond
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_inv_cond
    {
      ConditionType     = kschl;
      ConditionCategory = cndty;
      TaxType           = taxty;
    }
  field ( readonly : update ) ConditionType;
  create;
  update;
  delete;
}