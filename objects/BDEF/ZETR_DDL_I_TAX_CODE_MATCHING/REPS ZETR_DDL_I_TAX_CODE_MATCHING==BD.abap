managed implementation in class zbp_etr_ddl_i_tax_code_matchin unique;
strict ( 2 );

define behavior for zetr_ddl_i_tax_code_matching //alias <alias_name>
persistent table zetr_t_taxmc
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_taxmc
    {
      TaxProcedure  = kalsm;
      TaxCode       = mwskz;
      TaxType       = taxty;
      TaxRate       = taxrt;
      TaxExemption  = taxex;
      InvoiceType   = invty;
      ParentTaxType = txtyp;
      ParentTaxRate = txrtp;
    }
  field ( readonly : update ) TaxProcedure, TaxCode;
  create;
  update;
  delete;
}