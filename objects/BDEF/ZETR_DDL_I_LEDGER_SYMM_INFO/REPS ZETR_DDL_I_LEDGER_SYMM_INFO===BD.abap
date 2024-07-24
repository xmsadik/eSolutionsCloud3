managed implementation in class zbp_etr_ddl_i_l_symm_info unique;
strict ( 2 );

define behavior for ZETR_DDL_I_LEDGER_SYMM_INFO //alias <aliasS_name>
persistent table zetr_t_symmb
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly : update ) CompanyCode;

  mapping for zetr_t_symmb
    {
      CompanyCode = bukrs;
      Title       = mmtit;
      name        = name;
      surname     = surname;
      housenum    = house_num;
      adress1     = adress1;
      adress2     = adress2;
      countryu    = country_u;
      city        = city;
      ilce        = ilce;
      postalcode  = postal_code;
      contrdate   = contrdate;
      contrname   = contrname;
      contrno     = contrno;
      telnumber   = tel_number;
      faxnumber   = fax_number;
      email       = email;
      web         = web;
    }
}