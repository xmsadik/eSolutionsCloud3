projection;
strict ( 2 );

define behavior for zetr_ddl_p_incoming_delhead //alias <alias_name>
{
  use update;

  use action archiveDeliveries;
  use action statusUpdate;
  //  use action downloadInvoices;
  use action sendResponse;
//  use action setAsRejected;
  use action addNote;
  use action changePrintStatus;
  use action changeProcessStatus;

  use association _deliveryContents;
  use association _deliveryItems;
  use association _deliveryLogs;
}

define behavior for zetr_ddl_p_incoming_delcont //alias <alias_name>
{
  use update;

  use association _incomingDeliveries;
}

define behavior for zetr_ddl_p_incoming_delitem //alias <alias_name>
{
  use update;

  use association _incomingDeliveries;
}

define behavior for zetr_ddl_p_incoming_dellogs //alias <alias_name>
{
  use update;

  use association _incomingDeliveries;
}