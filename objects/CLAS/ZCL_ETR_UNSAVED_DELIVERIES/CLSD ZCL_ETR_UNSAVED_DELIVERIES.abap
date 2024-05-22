class-pool .
*"* class pool for class ZCL_ETR_UNSAVED_DELIVERIES

*"* local type definitions
include ZCL_ETR_UNSAVED_DELIVERIES====ccdef.

*"* class ZCL_ETR_UNSAVED_DELIVERIES definition
*"* public declarations
  include ZCL_ETR_UNSAVED_DELIVERIES====cu.
*"* protected declarations
  include ZCL_ETR_UNSAVED_DELIVERIES====co.
*"* private declarations
  include ZCL_ETR_UNSAVED_DELIVERIES====ci.
endclass. "ZCL_ETR_UNSAVED_DELIVERIES definition

*"* macro definitions
include ZCL_ETR_UNSAVED_DELIVERIES====ccmac.
*"* local class implementation
include ZCL_ETR_UNSAVED_DELIVERIES====ccimp.

*"* test class
include ZCL_ETR_UNSAVED_DELIVERIES====ccau.

class ZCL_ETR_UNSAVED_DELIVERIES implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_ETR_UNSAVED_DELIVERIES implementation
