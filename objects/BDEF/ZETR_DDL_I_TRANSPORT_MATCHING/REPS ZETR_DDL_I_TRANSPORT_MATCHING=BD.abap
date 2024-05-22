managed implementation in class zbp_etr_ddl_i_transport_match unique;
strict ( 2 );

define behavior for zetr_ddl_i_transport_matching //alias <alias_name>
persistent table zetr_t_trnmc
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_trnmc
    {
      ShippingType  = vsart;
      TransportType = trnsp;
    }
  field ( readonly : update ) ShippingType;
  create;
  update;
  delete;
}