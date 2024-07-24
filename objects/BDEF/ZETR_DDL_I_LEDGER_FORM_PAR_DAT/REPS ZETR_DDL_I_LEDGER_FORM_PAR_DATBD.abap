managed implementation in class zbp_etr_ddl_i_l_form_par_dat unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_FORM_PAR_DAT //ali= <ali=_name>
persistent table zetr_t_dopvr
//with unmanaged save
lock master
authorization master ( instance )
//etag m=ter <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) CompanyCode, BranchCode;

  mapping for zetr_t_dopvr
    {
      CompanyCode = bukrs;
      BranchCode  = bcode;
      xhana       = Xhana;
      rfagl       = rfagl;
      nbseg       = nbseg;
      rflop       = rflop;
      rskb1       = rskb1;
      waers       = waers;
      natpb       = Natpb;
      npost       = Npost;
      vdtys       = Vdtys;
      srli1       = Srli1;
      srli2       = Srli2;
      dcdno       = Dcdno;
      dcdgn       = Dcdgn;
      dfvhs       = Dfvhs;
      gtaob       = Gtaob;
      getfl       = Getfl;
      ikyls       = Ikyls;
      chktb       = Chktb;
      xhtml       = Xhtml;
      colac       = Colac;
      mznno       = Mznno;
    }
}