managed implementation in class zbp_etr_ddl_i_other_partner unique;
strict ( 2 );

define behavior for zetr_ddl_i_other_partner //alias <alias_name>
persistent table zetr_t_othp
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_othp
    {
      TaxID        = taxid;
      PartnerType  = prtty;
      Title        = title;
      FirstName    = namef;
      LastName     = namel;
      TaxOffice    = taxof;
      District     = distr;
      Street       = street;
      BlockName    = blckn;
      BuildingName = bldnm;
      BuildingNo   = bldno;
      RoomNumber   = roomn;
      PostBox      = pobox;
      Subdivision  = subdv;
      CityName     = cityn;
      PostCode     = pstcd;
      Region       = region;
      Country      = country;
      TelNumber    = telnm;
      FaxNumber    = faxnm;
      EMail        = email;
      Website      = website;
    }
  field ( readonly : update ) TaxID;
  create;
  update;
  delete;
}