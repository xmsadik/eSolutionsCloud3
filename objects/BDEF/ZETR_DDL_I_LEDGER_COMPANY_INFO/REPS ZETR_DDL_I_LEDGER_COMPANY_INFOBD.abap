managed implementation in class zbp_etr_ddl_i_l_company_info unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_COMPANY_INFO //alias <alias_name>
persistent table zetr_t_srkdb
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) CompanyCode;

  mapping for zetr_t_srkdb
    {
      CompanyCode            = bukrs;
      CompanyName1           = name1;
      CompanyName2           = name2;
      NaceCode               = nace_code;
      TaxId                  = stcd1;
      TaxOffice              = stcd2;
      adress1                = Adress1;
      adress2                = Adress2;
      HouseNum               = house_num;
      PostalCode             = postal_code;
      city                   = City;
      countryu               = Country_U;
      telnumber              = Tel_Number;
      faxnumber              = Fax_Number;
      email                  = Email;
      web                    = Web;
      legal                  = Legal;
      creator                = Creator;
      BranchType             = branch_type;
      days45                 = Days45;
      Ledger                 = rldnr;
      OpenningDocType        = ablart;
      ClosingDocType         = kblart;
      LedgerStartDate        = hdatab;
      LedgerEndDate          = hdatbi;
      LiquidationDate        = tastar;
      MaxItem                = maxit;
      MaxCursor              = maxcr;
      Entegrator             = intid;
      ApiAdress              = srapi;
      ApiUser                = sausr;
      ApiPass                = sapas;
      ApiDestination         = desti;
      ChartOfAcc             = ktopl;
      SendDataToOtherSystem  = tosys;
      GetDatafromOtherSystem = frsys;
      Sm59Dest               = sm59_dest;
      NoPart                 = no_part;
    }

}