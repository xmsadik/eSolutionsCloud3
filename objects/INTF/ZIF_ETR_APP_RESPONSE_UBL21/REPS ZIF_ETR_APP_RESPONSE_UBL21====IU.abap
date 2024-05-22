INTERFACE zif_etr_app_response_ubl21
  PUBLIC .

  INTERFACES:
    zif_etr_common_ubl21.

  ALIASES:
    IdentifierType       FOR zif_etr_common_ubl21~IdentifierType,
    DateType             FOR zif_etr_common_ubl21~DateType,
    TimeType             FOR zif_etr_common_ubl21~TimeType,
    TextType             FOR zif_etr_common_ubl21~TextType,
    SignatureType        FOR zif_etr_common_ubl21~SignatureType,
    CustomerPartyType    FOR zif_etr_common_ubl21~CustomerPartyType,
    SupplierPartyType    FOR zif_etr_common_ubl21~SupplierPartyType,
    PartyType            FOR zif_etr_common_ubl21~PartyType,
    DocumentResponseType FOR zif_etr_common_ubl21~DocumentResponseType,
    UBLExtensionsType    FOR zif_etr_common_ubl21~UBLExtensionsType.

  TYPES:
    BEGIN OF ApplicationResponseType,
      UBLExtensions    TYPE UBLExtensionsType,
      UBLVersionID     TYPE IdentifierType,
      CustomizationID  TYPE IdentifierType,
      ProfileID        TYPE IdentifierType,
      Id               TYPE IdentifierType,
      UUId             TYPE IdentifierType,
      IssueDate        TYPE DateType,
      IssueTime        TYPE TimeType,
      Note             TYPE STANDARD TABLE OF TextType WITH EMPTY KEY,
      Signature        TYPE STANDARD TABLE OF SignatureType WITH EMPTY KEY,
      SenderParty      TYPE PartyType,
      ReceiverParty    TYPE PartyType,
      DocumentResponse TYPE STANDARD TABLE OF DocumentResponseType WITH EMPTY KEY,
    END OF ApplicationResponseType.
ENDINTERFACE.