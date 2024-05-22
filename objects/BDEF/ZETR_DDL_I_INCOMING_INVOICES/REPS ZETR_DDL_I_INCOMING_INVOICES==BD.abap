managed implementation in class zbp_etr_ddl_i_incoming_invoice unique;
strict ( 2 );

define behavior for zetr_ddl_i_incoming_invoices alias InvoiceList
persistent table zetr_t_icinv
//with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
//late numbering
{

  mapping for zetr_t_icinv
    {
      DocumentUUID      = docui;
      CompanyCode       = bukrs;
      EnvelopeUUID      = envui;
      InvoiceUUID       = invui;
      InvoiceID         = invno;
      IntegratorUUID    = invii;
      QueryID           = invqi;
      TaxID             = taxid;
      Aliass            = aliass;
      DocumentDate      = bldat;
      ReceiveDate       = recdt;
      Amount            = wrbtr;
      TaxAmount         = fwste;
      Currency          = waers;
      ExchangeRate      = kursf;
      ProfileID         = prfid;
      InvoiceType       = invty;
      Printed           = prntd;
      Processed         = procs;
      Archived          = archv;
      LastNote          = lnote;
      LastNoteCreatedBy = luser;
      ResponseStatus    = resst;
      TRAStatusCode     = radsc;
      StatusDetail      = staex;
      PurchasingGroup   = ekgrp;
      PurchaseOrders    = ebeln;
    }

  //  create;
  update;
  //  delete;
  field ( readonly : update ) DocumentUUID;
  field ( readonly ) InvoiceID,
  InvoiceUUID,
  TaxID,
  DocumentDate,
  ReceiveDate,
  Amount,
  TaxAmount,
  ExchangeRate,
  Currency,
  InvoiceType,
  ProfileID,
  ResponseStatus,
  LastNoteCreatedBy,
  LastNote,
  Archived,
  Printed,
  ApplicationResponse,
  Processed;
//  field ( features : instance ) PurchasingGroup, PurchaseOrders;
  association _invoiceContents { create; }
  association _invoiceLogs { create; }

  action ( features : instance ) addNote parameter ZETR_DDL_I_NOTE_SELECTION result [1] $self;
  action ( features : instance ) changePrintStatus result [1] $self;
  action ( features : instance ) changeProcessStatus result [1] $self;
  action ( features : instance ) archiveInvoices result [1] $self;
  action ( features : instance ) statusUpdate result [1] $self;
  //  action ( features : instance ) downloadInvoices result [1] $self;
  action ( features : instance ) sendResponse parameter zetr_ddl_i_appresp_selection result [1] $self;
  action ( features : instance ) setAsRejected parameter zetr_ddl_i_reject_selection result [1] $self;
  //  action ( features : instance ) setAsRejected parameter ZETR_DDL_I_INVRESP_SELECTION result [1] $self;
}

define behavior for zetr_ddl_i_incoming_invcont alias InvoiceContents
persistent table zetr_t_arcd
//with unmanaged save
lock dependent by _incomingInvoices
authorization dependent by _incomingInvoices
//etag master <field_name>
//late numbering
{
  mapping for zetr_t_arcd
    {
      ArchiveUUID  = arcid;
      DocumentUUID = docui;
      ContentType  = conty;
      Content      = contn;
    }

  update;
  //  delete;
  field ( readonly ) DocumentUUID;
  field ( readonly : update ) ContentType;
  association _incomingInvoices;
}

define behavior for zetr_ddl_i_incoming_invlogs alias InvoiceLogs
persistent table zetr_t_logs
//with unmanaged save
lock dependent by _incomingInvoices
authorization dependent by _incomingInvoices
//etag master <field_name>
//late numbering
{
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
  update;
  //    delete;
  field ( readonly ) documentuuid, createdby, creationdate, creationtime, logcode, lognote;
  field ( readonly : update ) LogUUID;
  association _incomingInvoices;
}