projection;
strict ( 1 );

define behavior for zetr_ddl_p_outgoing_deliveries alias OutgoingDeliveries
{
//  use create;
  use update;
  use delete;

  use action sendDeliveries;
  use action archiveDeliveries;
  use action statusUpdate;
  use action setAsRejected;

  use association _deliveryContents { create; }
  use association _deliveryLogs { create; }
  use association _deliveryTransporters { create; }
  use association _deliveryTransportHeader { create; }
}

define behavior for zetr_ddl_p_outgoing_delcont alias DeliveryContents
{
  use update;
  use delete;

  use association _outgoingDeliveries;
}

define behavior for zetr_ddl_p_outgoing_dellogs alias Logs
{

  use association _outgoingDeliveries;
}

define behavior for zetr_ddl_p_outgoing_deltrns alias Transporters
{
  use update;
  use delete;

  use association _outgoingDeliveries;
}

define behavior for zetr_ddl_p_outgoing_deltdat alias TransportHeader
{
  use update;
  use delete;

  use association _outgoingDeliveries;
}