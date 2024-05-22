class-pool .
*"* class pool for class ZCX_ETR_REGULATIVE_EXCEPTION

*"* local type definitions
include ZCX_ETR_REGULATIVE_EXCEPTION==ccdef.

*"* class ZCX_ETR_REGULATIVE_EXCEPTION definition
*"* public declarations
  include ZCX_ETR_REGULATIVE_EXCEPTION==cu.
*"* protected declarations
  include ZCX_ETR_REGULATIVE_EXCEPTION==co.
*"* private declarations
  include ZCX_ETR_REGULATIVE_EXCEPTION==ci.
endclass. "ZCX_ETR_REGULATIVE_EXCEPTION definition

*"* macro definitions
include ZCX_ETR_REGULATIVE_EXCEPTION==ccmac.
*"* local class implementation
include ZCX_ETR_REGULATIVE_EXCEPTION==ccimp.

*"* test class
include ZCX_ETR_REGULATIVE_EXCEPTION==ccau.

class ZCX_ETR_REGULATIVE_EXCEPTION implementation.
*"* method's implementations
  include methods.
endclass. "ZCX_ETR_REGULATIVE_EXCEPTION implementation
