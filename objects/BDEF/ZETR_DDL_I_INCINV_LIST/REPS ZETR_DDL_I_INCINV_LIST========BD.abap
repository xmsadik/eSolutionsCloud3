unmanaged implementation in class zbp_etr_ddl_i_incinv_list unique;
strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for zetr_ddl_i_incinv_list //alias <alias_name>
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
  //  create;
  update;
  //  delete;
  field ( readonly : update ) DocumentUUID;
  association _invoiceContents;
  association _invoiceLogs;

  field ( readonly )
  TaxID,
  DocumentDate,
  ReceiveDate,
  ProfileID,
  InvoiceType,
  Printed,
  Processed,
  LastNote,
  ReferenceDocumentNumber;

  action ( features : instance ) archiveInvoices result [1] $self;
  action ( features : instance ) statusUpdate result [1] $self;
  action ( features : instance ) downloadInvoices result [1] $self;
  action ( features : instance ) sendResponse result [1] $self;
}

define behavior for zetr_ddl_i_incinv_content //alias <alias_name>
//late numbering
lock dependent by _incomingInvoices
authorization dependent by _incomingInvoices
//etag master <field_name>
{
  //  update;
  //  delete;
  field ( readonly ) DocumentUUID;
  field ( readonly : update ) ContentType;
  association _incomingInvoices;
}

define behavior for zetr_ddl_i_incinv_logs //alias <alias_name>
//late numbering
lock dependent by _incomingInvoices
authorization dependent by _incomingInvoices
//etag master <field_name>
{
  //  update;
  //  delete;
  field ( readonly ) DocumentUUID;
  field ( readonly : update ) LogUUID;
  association _incomingInvoices;
}