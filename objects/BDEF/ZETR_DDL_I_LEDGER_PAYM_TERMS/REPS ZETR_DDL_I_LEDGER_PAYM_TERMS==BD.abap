managed implementation in class zbp_etr_ddl_i_ledger_paym_term unique;
strict ( 2 );

define behavior for zetr_ddl_i_ledger_paym_terms alias PaymentTerms
persistent table zetr_t_odmtt
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) PaymentTerm;

  mapping for zetr_t_odmtt
    {
      PaymentTerm = oturu;
      Description = oturu_t;
    }
}