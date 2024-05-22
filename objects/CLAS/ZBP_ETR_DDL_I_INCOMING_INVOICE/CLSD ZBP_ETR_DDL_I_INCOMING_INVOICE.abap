class-pool .
*"* class pool for class ZBP_ETR_DDL_I_INCOMING_INVOICE

*"* local type definitions
include ZBP_ETR_DDL_I_INCOMING_INVOICEccdef.

*"* class ZBP_ETR_DDL_I_INCOMING_INVOICE definition
*"* public declarations
  include ZBP_ETR_DDL_I_INCOMING_INVOICEcu.
*"* protected declarations
  include ZBP_ETR_DDL_I_INCOMING_INVOICEco.
*"* private declarations
  include ZBP_ETR_DDL_I_INCOMING_INVOICEci.
endclass. "ZBP_ETR_DDL_I_INCOMING_INVOICE definition

*"* macro definitions
include ZBP_ETR_DDL_I_INCOMING_INVOICEccmac.
*"* local class implementation
include ZBP_ETR_DDL_I_INCOMING_INVOICEccimp.

*"* test class
include ZBP_ETR_DDL_I_INCOMING_INVOICEccau.

class ZBP_ETR_DDL_I_INCOMING_INVOICE implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_ETR_DDL_I_INCOMING_INVOICE implementation
