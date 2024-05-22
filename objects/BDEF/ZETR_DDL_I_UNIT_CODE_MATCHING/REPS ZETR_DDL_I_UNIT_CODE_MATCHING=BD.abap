managed implementation in class zbp_etr_ddl_i_unit_code_matchi unique;
strict ( 2 );

define behavior for zetr_ddl_i_unit_code_matching //alias <alias_name>
persistent table zetr_t_untmc
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_untmc
    {
      UnitOfMeasure = meins;
      UnitCode      = unitc;
    }
  field ( readonly : update ) UnitOfMeasure;
  create;
  update;
  delete;
}