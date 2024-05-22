class-pool .
*"* class pool for class ZCL_ETR_INVOICE_OPERATIONS

*"* local type definitions
include ZCL_ETR_INVOICE_OPERATIONS====ccdef.

*"* class ZCL_ETR_INVOICE_OPERATIONS definition
*"* public declarations
  include ZCL_ETR_INVOICE_OPERATIONS====cu.
*"* protected declarations
  include ZCL_ETR_INVOICE_OPERATIONS====co.
*"* private declarations
  include ZCL_ETR_INVOICE_OPERATIONS====ci.
endclass. "ZCL_ETR_INVOICE_OPERATIONS definition

*"* macro definitions
include ZCL_ETR_INVOICE_OPERATIONS====ccmac.
*"* local class implementation
include ZCL_ETR_INVOICE_OPERATIONS====ccimp.

*"* test class
include ZCL_ETR_INVOICE_OPERATIONS====ccau.

class ZCL_ETR_INVOICE_OPERATIONS implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_ETR_INVOICE_OPERATIONS implementation
