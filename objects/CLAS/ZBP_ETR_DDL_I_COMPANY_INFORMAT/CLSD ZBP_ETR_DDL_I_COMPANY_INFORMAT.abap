class-pool .
*"* class pool for class ZBP_ETR_DDL_I_COMPANY_INFORMAT

*"* local type definitions
include ZBP_ETR_DDL_I_COMPANY_INFORMATccdef.

*"* class ZBP_ETR_DDL_I_COMPANY_INFORMAT definition
*"* public declarations
  include ZBP_ETR_DDL_I_COMPANY_INFORMATcu.
*"* protected declarations
  include ZBP_ETR_DDL_I_COMPANY_INFORMATco.
*"* private declarations
  include ZBP_ETR_DDL_I_COMPANY_INFORMATci.
endclass. "ZBP_ETR_DDL_I_COMPANY_INFORMAT definition

*"* macro definitions
include ZBP_ETR_DDL_I_COMPANY_INFORMATccmac.
*"* local class implementation
include ZBP_ETR_DDL_I_COMPANY_INFORMATccimp.

*"* test class
include ZBP_ETR_DDL_I_COMPANY_INFORMATccau.

class ZBP_ETR_DDL_I_COMPANY_INFORMAT implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_ETR_DDL_I_COMPANY_INFORMAT implementation
