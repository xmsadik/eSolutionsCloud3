managed implementation in class zbp_etr_ddl_i_outgoing_invoice unique;
strict ( 1 );

define behavior for zetr_ddl_i_outgoing_invoices alias OutgoingInvoices
//persistent table zetr_t_oginv
with unmanaged save
lock master
authorization master ( global, instance )
//etag master <field_name>
//late numbering
{
  //  create;
  update ( features : instance );
  delete ( features : instance );
  field ( readonly : update ) DocumentUUID;
  field ( features : instance )
  ProfileID,
  eArchiveType,
  InternetSale,
  Aliass,
  InvoiceType,
  TaxType,
  SerialPrefix,
  XSLTTemplate,
  TaxExemption,
  CollectItems,
  InvoiceNote,
  StatusCode,
  StatusDetail,
  Response,
  TransportType,
  TRAStatusCode;

  //  mapping for zetr_t_oginv
  //    {
  //      DocumentUUID          = docui;
  //      CompanyCode           = bukrs;
  //      DocumentNumber        = belnr;
  //      FiscalYear            = gjahr;
  //      ReferenceDocumentType = awtyp;
  //      DocumentType          = docty;
  //      Plant                 = werks;
  //      BusinessArea          = gsber;
  //      SalesOrganization     = vkorg;
  //      DistributionChannel   = vtweg;
  //      PartnerNumber         = partner;
  //      TaxID                 = taxid;
  //      Aliass                = aliass;
  //      DocumentDate          = bldat;
  //      Amount                = wrbtr;
  //      TaxAmount             = fwste;
  //      ExchangeRate          = kursf;
  //      Currency              = waers;
  //      ProfileID             = prfid;
  //      InvoiceType           = invty;
  //      TaxType               = taxty;
  //      SerialPrefix          = serpr;
  //      XSLTTemplate          = xsltt;
  //      TaxExemption          = taxex;
  //      ExemptionExists       = texex;
  //      Reversed              = revch;
  //      ReverseDate           = revdt;
  //      Printed               = prntd;
  //      Sender                = sndus;
  //      SendDate              = snddt;
  //      SendTime              = sndtm;
  //      InvoiceIDSaved        = inids;
  //      CollectItems          = itmcl;
  //      TransportType         = trnsp;
  //      StatusCode            = stacd;
  //      StatusDetail          = staex;
  //      Response              = resst;
  //      TRAStatusCode         = radsc;
  //      Resendable            = rsend;
  //      ActualExportDate      = raded;
  //      CustomsDocumentNo     = cedrn;
  //      CustomsReferenceNo    = radrn;
  //      IntegratorDocumentID  = invii;
  //      ReportID              = rprid;
  //      EnvelopeUUID          = envui;
  //      InvoiceUUID           = invui;
  //      InvoiceID             = invno;
  //      eArchiveType          = eatyp;
  //      InternetSale          = intsl;
  //      InvoiceNote           = inote;
  //      Archived              = archv;
  //      CreatedBy             = ernam;
  //      CreateDate            = erdat;
  //      CreateTime            = erzet;
  //    }

  association _invoiceContents { }
  association _invoiceLogs { create; }

  action ( features : instance ) sendInvoices result [1] $self;
  action ( features : instance ) archiveInvoices result [1] $self;
  action ( features : instance ) statusUpdate result [1] $self;
  action ( features : instance ) setAsRejected parameter zetr_ddl_i_reject_selection result [1] $self;
}

define behavior for zetr_ddl_i_outinv_logs alias Logs
persistent table zetr_t_logs
lock dependent by _outgoingInvoices
authorization dependent by _outgoingInvoices
//etag master <field_name>
{
  field ( readonly : update ) LogUUID, DocumentUUID;
  association _outgoingInvoices;
  mapping for zetr_t_logs
    {
      LogUUID      = logui;
      DocumentUUID = docui;
      CreatedBy    = uname;
      CreationDate = datum;
      CreationTime = uzeit;
      LogCode      = logcd;
      LogNote      = lnote;
    }
}

define behavior for zetr_ddl_i_outgoing_invcont alias InvoiceContents
//persistent table zetr_t_arcd
with unmanaged save
lock dependent by _outgoingInvoices
authorization dependent by _outgoingInvoices
//etag master <field_name>
//late numbering
{
  //  mapping for zetr_t_arcd
  //    {
  //      DocumentUUID = docui;
  //      ContentType  = conty;
  //      DocumentType = docty;
  //      Content      = contn;
  //    }

  update;
  delete;
  field ( readonly ) DocumentUUID;
  field ( readonly : update ) ContentType, DocumentType;
  association _outgoingInvoices;
}