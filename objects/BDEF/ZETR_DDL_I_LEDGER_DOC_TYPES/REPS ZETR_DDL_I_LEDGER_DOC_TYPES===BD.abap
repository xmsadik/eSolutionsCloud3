managed implementation in class zbp_etr_ddl_i_l_doc_types unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_DOC_TYPES //alias <alias_name>
persistent table zetr_t_beltr
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) DocType;

  mapping for zetr_t_beltr
    {
      DocType        = blart;
      DocTypeDesc    = blart_t;
      GibDocType     = gbtur;
      paymentTerm    = oturu;
      GibDocTypeDesc = gibbta;
      OpeningClosing = ocblg;
    }

}