class-pool .
*"* class pool for class ZCL_ETR_OUTGOING_INVOICE

*"* local type definitions
include ZCL_ETR_OUTGOING_INVOICE======ccdef.

*"* class ZCL_ETR_OUTGOING_INVOICE definition
*"* public declarations
  include ZCL_ETR_OUTGOING_INVOICE======cu.
*"* protected declarations
  include ZCL_ETR_OUTGOING_INVOICE======co.
*"* private declarations
  include ZCL_ETR_OUTGOING_INVOICE======ci.
endclass. "ZCL_ETR_OUTGOING_INVOICE definition

*"* macro definitions
include ZCL_ETR_OUTGOING_INVOICE======ccmac.
*"* local class implementation
include ZCL_ETR_OUTGOING_INVOICE======ccimp.

*"* test class
include ZCL_ETR_OUTGOING_INVOICE======ccau.

class ZCL_ETR_OUTGOING_INVOICE implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_ETR_OUTGOING_INVOICE implementation
