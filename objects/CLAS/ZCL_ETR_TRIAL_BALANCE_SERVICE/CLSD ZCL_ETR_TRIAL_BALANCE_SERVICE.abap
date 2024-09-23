class-pool .
*"* class pool for class ZCL_ETR_TRIAL_BALANCE_SERVICE

*"* local type definitions
include ZCL_ETR_TRIAL_BALANCE_SERVICE=ccdef.

*"* class ZCL_ETR_TRIAL_BALANCE_SERVICE definition
*"* public declarations
  include ZCL_ETR_TRIAL_BALANCE_SERVICE=cu.
*"* protected declarations
  include ZCL_ETR_TRIAL_BALANCE_SERVICE=co.
*"* private declarations
  include ZCL_ETR_TRIAL_BALANCE_SERVICE=ci.
endclass. "ZCL_ETR_TRIAL_BALANCE_SERVICE definition

*"* macro definitions
include ZCL_ETR_TRIAL_BALANCE_SERVICE=ccmac.
*"* local class implementation
include ZCL_ETR_TRIAL_BALANCE_SERVICE=ccimp.

*"* test class
include ZCL_ETR_TRIAL_BALANCE_SERVICE=ccau.

class ZCL_ETR_TRIAL_BALANCE_SERVICE implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_ETR_TRIAL_BALANCE_SERVICE implementation
