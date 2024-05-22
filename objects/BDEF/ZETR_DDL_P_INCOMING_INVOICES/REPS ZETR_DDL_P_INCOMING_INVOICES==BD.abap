projection;
strict ( 2 );

define behavior for zetr_ddl_p_incoming_invoices alias InvoiceList
{
  use update;
  //  use create;

  use action archiveInvoices;
  use action statusUpdate;
  //  use action downloadInvoices;
  use action sendResponse;
  use action setAsRejected;
  use action addNote;
  use action changePrintStatus;
  use action changeProcessStatus;

  use association _invoiceContents;
  use association _invoiceLogs;
}

define behavior for zetr_ddl_p_incoming_invcont alias InvoiceContents
{
  use update;
  use association _incomingInvoices;
}

define behavior for zetr_ddl_p_incoming_invlogs alias InvoiceLogs
{
  use update;
  use association _incomingInvoices;
}