managed implementation in class zbp_etr_ddl_i_outgoing_deliver unique;
strict ( 1 );

define behavior for zetr_ddl_i_outgoing_deliveries alias OutgoingDeliveries
//persistent table zetr_t_ogdlv
with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  //  create;
  update ( features : instance );
  delete ( features : instance );

  field ( readonly : update ) DocumentUUID;
  field ( readonly ) TaxID;
  field ( features : instance )
  ProfileID,
  Aliass,
  DeliveryType,
  SerialPrefix,
  XSLTTemplate,
  CollectItems,
  DeliveryNote,
  ActualDeliveryDate,
  ActualDeliveryTime,
  VehiclePlate,
  TransportCompanyTaxID,
  TransportCompanyTitle,
  DeliveryAddressStreet,
  DeliveryAddressBuildingName,
  DeliveryAddressBuildingNumber,
  DeliveryAddressRegion,
  DeliveryAddressSubdivision,
  DeliveryAddressCity,
  DeliveryAddressCountry,
  DeliveryAddressPostalCode,
  DeliveryAddressTelephone,
  DeliveryAddressFax,
  DeliveryAddressEMail,
  DeliveryAddressWebsite,
  PrintedDocumentDate,
  PrintedDocumentNumber;

  mapping for zetr_t_ogdlv
    {
      DocumentUUID             = docui;
      CompanyCode              = bukrs;
      DocumentNumber           = belnr;
      FiscalYear               = gjahr;
      DocumentType             = awtyp;
      ObjectType               = objtype;
      ReferenceDocumentType    = docty;
      Plant                    = werks;
      StorageLocation          = lgort;
      ReceivingPlant           = umwrk;
      ReceivingStorageLocation = umlgo;
      BusinessArea             = gsber;
      MovementType             = bwart;
      SpecialStockIndicator    = sobkz;
      PartnerNumber            = partner;
      TaxID                    = taxid;
      Aliass                   = aliass;
      DocumentDate             = bldat;
      ProfileID                = prfid;
      DeliveryType             = dlvty;
      SerialPrefix             = serpr;
      XSLTTemplate             = xsltt;
      Reversed                 = revch;
      ReverseDate              = revdt;
      Archived                 = archv;
      PrintedDocumentNumber    = pdnum;
      PrintedDocumentDate      = pddat;
      Printed                  = prntd;
      Sender                   = sndus;
      SendDate                 = snddt;
      SendTime                 = sndtm;
      DeliveryIDSaved          = dlvds;
      CollectItems             = itmcl;
      StatusCode               = stacd;
      StatusDetail             = staex;
      Response                 = resst;
      ResponseUUID             = ruuid;
      ItemResponse             = itmrs;
      TRAStatusCode            = radsc;
      Resendable               = rsend;
      IntegratorDocumentID     = dlvii;
      EnvelopeUUID             = envui;
      DeliveryUUID             = dlvui;
      DeliveryID               = dlvno;
      DeliveryNote             = dnote;
      CreatedBy                = ernam;
      CreateDate               = erdat;
      CreateTime               = erzet;
    }

  association _deliveryContents { create; }
  association _deliveryLogs { create; }
  association _deliveryTransporters { create; }
  association _deliveryTransportHeader { }

  action ( features : instance ) sendDeliveries result [1] $self;
  action ( features : instance ) archiveDeliveries result [1] $self;
  action ( features : instance ) statusUpdate result [1] $self;
  action ( features : instance ) setAsRejected parameter ZETR_DDL_I_NOTE_SELECTION result [1] $self;
}

define behavior for zetr_ddl_i_outgoing_delcont alias DeliveryContents
persistent table zetr_t_arcd
lock dependent by _outgoingDeliveries
authorization dependent by _outgoingDeliveries
//etag master <field_name>
{
  update;
  delete;

  field ( readonly ) DocumentUUID;
  field ( readonly : update ) DocumentType, ContentType;

  association _outgoingDeliveries;

  mapping for zetr_t_arcd
    {
      ArchiveUUID  = arcid;
      DocumentUUID = docui;
      ContentType  = conty;
      DocumentType = docty;
      Content      = contn;
    }
}

define behavior for zetr_ddl_i_outgoing_dellogs alias Logs
persistent table zetr_t_logs
lock dependent by _outgoingDeliveries
authorization dependent by _outgoingDeliveries
//etag master <field_name>
{
  //  update;
  //  delete;

  field ( readonly : update ) LogUUID, DocumentUUID;

  association _outgoingDeliveries;

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

define behavior for zetr_ddl_i_outgoing_deltrns alias Transporters
persistent table zetr_t_odti
lock dependent by _outgoingDeliveries
authorization dependent by _outgoingDeliveries
//etag master <field_name>
{
  update;
  delete;

  field ( readonly ) DocumentUUID;
  field ( readonly : update ) ItemNumber;

  association _outgoingDeliveries;

  mapping for zetr_t_odti
    {
      DocumentUUID    = docui;
      ItemNumber      = buzei;
      TransporterType = trnst;
      Transporter     = trnsp;
      Title           = title;
      FirstName       = namef;
      LastName        = namel;
    }
}

define behavior for zetr_ddl_i_outgoing_deltdat alias TransportHeader
persistent table zetr_t_odth
lock dependent by _outgoingDeliveries
authorization dependent by _outgoingDeliveries
//etag master <field_name>
{
  update;
//  delete;

  field ( readonly ) DocumentUUID;

  association _outgoingDeliveries;

  mapping for zetr_t_odth
    {
      DocumentUUID                  = docui;
      ActualDeliveryDate            = addat;
      ActualDeliveryTime            = adtim;
      VehiclePlate                  = vhcll;
      TransportCompanyTaxID         = taxid;
      TransportCompanyTitle         = title;
      DeliveryAddressStreet         = street;
      DeliveryAddressBuildingName   = bldnm;
      DeliveryAddressBuildingNumber = bldno;
      DeliveryAddressSubdivision    = subdv;
      DeliveryAddressCity           = cityn;
      DeliveryAddressPostalCode     = pstcd;
      DeliveryAddressRegion         = region;
      DeliveryAddressCountry        = country;
      DeliveryAddressTelephone      = telnm;
      DeliveryAddressFax            = faxnm;
      DeliveryAddressEMail          = email;
      DeliveryAddressWebsite        = website;
    }
}