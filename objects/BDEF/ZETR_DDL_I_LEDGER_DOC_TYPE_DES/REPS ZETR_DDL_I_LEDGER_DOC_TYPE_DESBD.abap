managed implementation in class zbp_etr_ddl_i_l_doc_type_des unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_DOC_TYPE_DES //alias <alias_name>
persistent table zetr_t_btack
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) GibDocTypeDesc;

  mapping for zetr_t_btack
    {
      GibDocTypeDesc = gibbta;
    }
}