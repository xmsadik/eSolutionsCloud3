class-pool .
*"* class pool for class ZBP_ETR_DDL_I_FINANCE_ACCOUNTS

*"* local type definitions
include ZBP_ETR_DDL_I_FINANCE_ACCOUNTSccdef.

*"* class ZBP_ETR_DDL_I_FINANCE_ACCOUNTS definition
*"* public declarations
  include ZBP_ETR_DDL_I_FINANCE_ACCOUNTScu.
*"* protected declarations
  include ZBP_ETR_DDL_I_FINANCE_ACCOUNTSco.
*"* private declarations
  include ZBP_ETR_DDL_I_FINANCE_ACCOUNTSci.
endclass. "ZBP_ETR_DDL_I_FINANCE_ACCOUNTS definition

*"* macro definitions
include ZBP_ETR_DDL_I_FINANCE_ACCOUNTSccmac.
*"* local class implementation
include ZBP_ETR_DDL_I_FINANCE_ACCOUNTSccimp.

*"* test class
include ZBP_ETR_DDL_I_FINANCE_ACCOUNTSccau.

class ZBP_ETR_DDL_I_FINANCE_ACCOUNTS implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_ETR_DDL_I_FINANCE_ACCOUNTS implementation
