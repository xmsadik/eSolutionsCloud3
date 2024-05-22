managed implementation in class zbp_etr_ddl_i_company_informat unique;
strict ( 2 );

define behavior for zetr_ddl_i_company_information //alias <alias_name>
persistent table zetr_t_cmpin
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_cmpin
    {
      CompanyCode  = bukrs;
      Title        = title;
      FirstName    = namef;
      LastName     = namel;
      SearchTerm   = sortl;
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
  field ( readonly : update ) CompanyCode;
  field ( mandatory ) Title, Street, Subdivision, CityName, Country, SearchTerm;
  create;
  update;
  delete;
  association _companyIdentification { create; }
  association _companyParameters { create; }
  association _referenceClasses { create; }
  association _userAuthorizations { create; }
}

define behavior for zetr_ddl_i_company_identify //alias <alias_name>
persistent table zetr_t_cmppi
lock dependent by _companyInformation
authorization dependent by _companyInformation
//etag master <field_name>
{
  mapping for zetr_t_cmppi
    {
      CompanyCode         = bukrs;
      PartyIdentification = prtid;
      Value               = value;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) PartyIdentification;
  field ( mandatory ) Value;
  association _companyInformation;
}

define behavior for zetr_ddl_i_company_parameters //alias <alias_name>
persistent table zetr_t_cmpcp
lock dependent by _companyInformation
authorization dependent by _companyInformation
//etag master <field_name>
{
  mapping for zetr_t_cmpcp
    {
      CompanyCode     = bukrs;
      CustomParameter = cuspa;
      Value           = value;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) CustomParameter;
  field ( mandatory ) Value;
  association _companyInformation;
}

define behavior for zetr_ddl_i_reference_classes //alias <alias_name>
persistent table zetr_t_refcl
lock dependent by _companyInformation
authorization dependent by _companyInformation
//etag master <field_name>
{
  mapping for zetr_t_refcl
    {
      CompanyCode        = bukrs;
      ParentClassName    = prncl;
      ReferenceClassName = refcl;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) ParentClassName;
  field ( mandatory ) ReferenceClassName;
  association _companyInformation;
}

define behavior for zetr_ddl_i_user_authorizations //alias <alias_name>
persistent table zetr_t_usaut
lock dependent by _companyInformation
authorization dependent by _companyInformation
//etag master <field_name>
{
  mapping for zetr_t_usaut
    {
      CompanyCode                  = bukrs;
      Username                     = uname;
      OutgoingInvoiceStatusChange  = ogisc;
      OutgoingDeliveryStatusChange = ogdsc;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) Username;
  association _companyInformation;
}