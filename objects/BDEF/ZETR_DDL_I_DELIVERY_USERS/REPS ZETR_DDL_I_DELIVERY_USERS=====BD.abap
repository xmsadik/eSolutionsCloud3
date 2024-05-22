managed implementation in class zbp_etr_ddl_i_delivery_users unique;
strict ( 2 );

define behavior for zetr_ddl_i_delivery_users //alias <alias_name>
persistent table zetr_t_dlv_ruser
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_dlv_ruser
    {
      Taxid        = taxid;
      RecordNo     = recno;
      Title        = title;
      Aliass       = aliass;
      RegisterDate = regdt;
      RegisterTime = regtm;
      DefaultAlias = defal;
      TaxpayerType = txpty;
    }
  field ( readonly ) Taxid, RecordNo, Aliass, RegisterDate, RegisterTime, Title, TaxpayerType, TaxpayerTypeText;
  create;
  update;
  delete;
  static action modify_list parameter ZETR_DDL_I_COMPANY_SELECTION;
}