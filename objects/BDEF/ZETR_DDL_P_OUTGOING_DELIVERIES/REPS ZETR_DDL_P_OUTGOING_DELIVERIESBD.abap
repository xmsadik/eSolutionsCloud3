projection;
strict ( 1 );

define behavior for zetr_ddl_p_outgoing_deliveries alias OutgoingDeliveries
{
  use update;
  use delete;

  use action sendDeliveries;
  use action archiveDeliveries;
  use action statusUpdate;
  use action setAsRejected;
  use action createWithoutReference;

  use association _deliveryContents { }
  use association _deliveryLogs { }
  use association _deliveryTransporters { create; }
  use association _deliveryTransportHeader { }
  use association _deliveryItems { create; }
}

define behavior for zetr_ddl_p_outgoing_delcont alias DeliveryContents
{
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

define behavior for zetr_ddl_p_outgoing_delitem alias Items
{
  use update;
  use delete;

  use association _outgoingDeliveries;
}