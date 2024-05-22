managed implementation in class zbp_etr_ddl_i_unit_codes unique;
strict ( 2 );

define behavior for zetr_ddl_i_unit_codes
//persistent table zetr_t_units
with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_units
    {
      UnitCode = unitc;
    }
  field ( readonly : update ) UnitCode;
  create;
  update;
  delete;
}