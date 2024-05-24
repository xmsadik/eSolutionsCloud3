managed implementation in class zbp_etr_ddl_i_incoming_delhead unique;
strict ( 2 );

define behavior for zetr_ddl_i_incoming_delhead alias DeliveryList
persistent table zetr_t_icdlv
lock master
authorization master ( instance )
//etag master <field_name>
{
  mapping for zetr_t_icdlv
    {
      DocumentUUID          = docui;
      CompanyCode           = bukrs;
      EnvelopeUUID          = envui;
      DeliveryUUID          = dlvui;
      DeliveryID            = dlvno;
      IntegratorUUID        = dlvii;
      QueryID               = dlvqi;
      TaxID                 = taxid;
      Aliass                = aliass;
      DocumentDate          = bldat;
      ReceiveDate           = recdt;
      Amount                = wrbtr;
      Currency              = waers;
      ProfileID             = prfid;
      DeliveryType          = dlvty;
      Printed               = prntd;
      Processed             = procs;
      Archived              = archv;
      LatestNote            = lnote;
      LatestNoteCreatedBy   = luser;
      ResponseStatus        = resst;
      TRAStatusCode         = radsc;
      StatusDetail          = staex;
      ResponseUUID          = ruuid;
      ResponseUUIDConverted = ruuidc;
      ItemResponseStatus    = itmrs;
    }
  //  create;
  update;
  //  delete;
  field ( readonly : update ) DocumentUUID;
  field ( readonly )
  CompanyCode,
  EnvelopeUUID,
  DeliveryUUID,
  DeliveryID,
  IntegratorUUID,
  QueryID,
  TaxID,
  Aliass,
  DocumentDate,
  ReceiveDate,
  Amount,
  Currency,
  ProfileID,
  DeliveryType,
  Printed,
  Processed,
  Archived,
  LatestNote,
  LatestNoteCreatedBy,
  ResponseStatus,
  TRAStatusCode,
  StatusDetail,
  ResponseUUID,
  ResponseUUIDConverted,
  ItemResponseStatus;

  association _deliveryContents { create; }
  association _deliveryItems;
  association _deliveryLogs { create; }


  action ( features : instance ) addNote parameter ZETR_DDL_I_NOTE_SELECTION result [1] $self;
  action ( features : instance ) changePrintStatus result [1] $self;
  action ( features : instance ) changeProcessStatus result [1] $self;
  action ( features : instance ) archiveDeliveries result [1] $self;
  action ( features : instance ) statusUpdate result [1] $self;
  action ( features : instance ) sendResponse parameter zetr_ddl_i_dlvresp_selection result [1] $self;
}

define behavior for zetr_ddl_i_incoming_delcont alias DeliveryContents
persistent table zetr_t_arcd
lock dependent by _incomingDeliveries
authorization dependent by _incomingDeliveries
//etag master <field_name>
{
  mapping for zetr_t_arcd
    {
      DocumentUUID = docui;
      ContentType  = conty;
      DocumentType = docty;
      Content      = contn;
    }
  update;
  //  delete;
  field ( readonly ) DocumentUUID;
  field ( readonly : update ) ContentType, DocumentType;
  association _incomingDeliveries;
}

define behavior for zetr_ddl_i_incoming_delitem alias DeliveryItems
persistent table zetr_t_icdli
lock dependent by _incomingDeliveries
authorization dependent by _incomingDeliveries
//etag master <field_name>
{
  mapping for zetr_t_icdli
    {
      DocumentUUID                   = docui;
      ItemNo                         = linno;
      MaterialDescription            = mdesc;
      Description                    = descr;
      BuyerItemIdentification        = buyii;
      SellerItemIdentification       = selii;
      ManufacturerItemIdentification = manii;
      Price                          = netpr;
      Currency                       = waers;
      Quantity                       = menge;
      UnitOfMeasure                  = meins;
      ReceivedQuantity               = recqt;
      UnacceptableQuantity           = napqt;
      MissingQuantity                = misqt;
      ExcessQuantity                 = ovsqt;
      RejectedProductDescription     = rejpd;
      LateDeliveryCompliant          = ldlvc;
    }
  update;
  //  delete;
  field ( readonly )
  DocumentUUID,
  MaterialDescription,
  Description,
  BuyerItemIdentification,
  SellerItemIdentification,
  ManufacturerItemIdentification,
  Price,
  Currency,
  Quantity,
  UnitOfMeasure;
  field ( readonly : update ) ItemNo;
  association _incomingDeliveries;
}

define behavior for zetr_ddl_i_incoming_dellogs alias DeliveryLogs
persistent table zetr_t_logs
lock dependent by _incomingDeliveries
authorization dependent by _incomingDeliveries
//etag master <field_name>
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
  //  delete;
  field ( readonly ) documentuuid, createdby, creationdate, creationtime, logcode, lognote;
  field ( readonly : update ) LogUUID;
  association _incomingDeliveries;
}