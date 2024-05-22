managed implementation in class zbp_etr_ddl_i_archive_paramete unique;
strict ( 2 );

define behavior for zetr_ddl_i_archive_parameters //alias <alias_name>
persistent table zetr_t_eapar
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_eapar
    {
      CompanyCode    = bukrs;
      ValidFrom      = datab;
      ValidTo        = datbi;
      Integrator     = intid;
      WSEndpoint     = wsend;
      WSEndpointAlt  = wsena;
      WSUser         = wsusr;
      WSPassword     = wspwd;
      GenerateSerial = genid;
      Barcode        = barcode;
    }
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode;
  association _customParameters { create; }
  association _invoiceSerials { create; }
  association _xsltTemplates { create; }
  association _invoiceRules { create; }
}

define behavior for zetr_ddl_i_archive_custom //alias <alias_name>
persistent table zetr_t_eacus
lock dependent by _earchiveParameters
authorization dependent by _earchiveParameters
//etag master <field_name>
{
  mapping for zetr_t_eacus
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
  association _earchiveParameters;
}

define behavior for zetr_ddl_i_archive_serials //alias <alias_name>
persistent table zetr_t_easer
lock dependent by _earchiveParameters
authorization dependent by _earchiveParameters
//etag master <field_name>
{
  mapping for zetr_t_easer
    {
      CompanyCode       = bukrs;
      SerialPrefix      = serpr;
      Description       = descr;
      NextSerial        = nxtsp;
      MainSerial        = maisp;
      NumberRangeNumber = numrn;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) SerialPrefix;
  association _earchiveParameters;
}

define behavior for zetr_ddl_i_archive_xslttemp //alias <alias_name>
persistent table zetr_t_eaxslt
lock dependent by _earchiveParameters
authorization dependent by _earchiveParameters
//etag master <field_name>
{
  mapping for zetr_t_eaxslt
    {
      CompanyCode     = bukrs;
      XSLTTemplate    = xsltt;
      DefaultTemplate = deflt;
      XSLTContent     = xsltc;
      Filename        = filen;
      Mimetype        = mimet;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) XSLTTemplate;
  association _earchiveParameters;
}

define behavior for zetr_ddl_i_archive_rules //alias <alias_name>
persistent table zetr_t_earules
lock dependent by _earchiveParameters
authorization dependent by _earchiveParameters
//etag master <field_name>
{
  mapping for zetr_t_earules
    {
      CompanyCode            = bukrs;
      RuleType               = rulet;
      RuleItemNumber         = rulen;
      RuleDescription        = descr;
      ReferenceDocumentType  = awtyp;
      InvoiceTypeInput       = ityin;
      SalesOrganization      = vkorg;
      DistributionChannel    = vtweg;
      Plant                  = werks;
      BillingDocumentType    = sddty;
      InvoiceReceiptType     = mmdty;
      AccountingDocumentType = fidty;
      Partner                = partner;
      SalesDocument          = vbeln;
      InvoiceType            = ityou;
      TaxExemption           = taxex;
      Exclude                = excld;
      SerialPrefix           = serpr;
      XSLTTemplate           = xsltt;
      Note                   = note;
    }
  update;
  delete;
  field ( readonly ) CompanyCode;
  field ( readonly : update ) RuleType, RuleItemNumber;
  association _earchiveParameters;
}