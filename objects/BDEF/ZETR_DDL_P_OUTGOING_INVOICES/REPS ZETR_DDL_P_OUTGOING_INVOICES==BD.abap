projection;
strict ( 1 );

define behavior for zetr_ddl_p_outgoing_invoices alias OutgoingInvoices
{
  use update;
  use delete;
  use association _invoiceContents;
  use association _invoiceLogs;
  use action sendInvoices;
  use action archiveInvoices;
  use action statusUpdate;
  use action setAsRejected;
}

define behavior for zetr_ddl_p_outgoing_invcont alias InvoiceContents
{
  use association _outgoingInvoices;
}

define behavior for zetr_ddl_p_outinv_logs alias Logs
{
  use association _outgoingInvoices;
}