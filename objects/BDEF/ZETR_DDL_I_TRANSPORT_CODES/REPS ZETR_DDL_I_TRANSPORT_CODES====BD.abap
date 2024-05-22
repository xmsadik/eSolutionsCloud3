managed implementation in class zbp_etr_ddl_i_transport_codes unique;
strict ( 2 );

define behavior for zetr_ddl_i_transport_codes //alias <alias_name>
//persistent table <???>
with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_trnsp
    {
      TransportCode = trnsp;
    }
  create;
  update;
  delete;
  field ( readonly : update ) TransportCode;
}