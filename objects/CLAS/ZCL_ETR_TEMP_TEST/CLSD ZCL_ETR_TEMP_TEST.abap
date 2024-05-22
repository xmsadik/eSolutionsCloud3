class-pool .
*"* class pool for class ZCL_ETR_TEMP_TEST

*"* local type definitions
include ZCL_ETR_TEMP_TEST=============ccdef.

*"* class ZCL_ETR_TEMP_TEST definition
*"* public declarations
  include ZCL_ETR_TEMP_TEST=============cu.
*"* protected declarations
  include ZCL_ETR_TEMP_TEST=============co.
*"* private declarations
  include ZCL_ETR_TEMP_TEST=============ci.
endclass. "ZCL_ETR_TEMP_TEST definition

*"* macro definitions
include ZCL_ETR_TEMP_TEST=============ccmac.
*"* local class implementation
include ZCL_ETR_TEMP_TEST=============ccimp.

*"* test class
include ZCL_ETR_TEMP_TEST=============ccau.

class ZCL_ETR_TEMP_TEST implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_ETR_TEMP_TEST implementation
