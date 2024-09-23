managed implementation in class zbp_etr_ddl_i_ledger_tradoc_ty unique;
strict ( 2 );

define behavior for zetr_ddl_i_ledger_tradoc_types alias TRADocumentTypes
persistent table zetr_t_gibbt
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) TRADocumentType;

  mapping for zetr_t_gibbt
    {
      TRADocumentType = gbtur;
      Description     = gbtur_t;
    }
}