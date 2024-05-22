class-pool .
*"* class pool for class ZBP_ETR_DDL_I_DELIVERY_USERS

*"* local type definitions
include ZBP_ETR_DDL_I_DELIVERY_USERS==ccdef.

*"* class ZBP_ETR_DDL_I_DELIVERY_USERS definition
*"* public declarations
  include ZBP_ETR_DDL_I_DELIVERY_USERS==cu.
*"* protected declarations
  include ZBP_ETR_DDL_I_DELIVERY_USERS==co.
*"* private declarations
  include ZBP_ETR_DDL_I_DELIVERY_USERS==ci.
endclass. "ZBP_ETR_DDL_I_DELIVERY_USERS definition

*"* macro definitions
include ZBP_ETR_DDL_I_DELIVERY_USERS==ccmac.
*"* local class implementation
include ZBP_ETR_DDL_I_DELIVERY_USERS==ccimp.

*"* test class
include ZBP_ETR_DDL_I_DELIVERY_USERS==ccau.

class ZBP_ETR_DDL_I_DELIVERY_USERS implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_ETR_DDL_I_DELIVERY_USERS implementation
