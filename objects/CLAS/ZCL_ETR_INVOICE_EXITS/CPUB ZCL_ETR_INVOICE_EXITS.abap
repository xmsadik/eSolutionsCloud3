CLASS zcl_etr_invoice_exits DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES: BEGIN OF mty_accdoc_header,
             companycode                    TYPE bukrs,
             accountingdocument             TYPE belnr_d,
             fiscalyear                     TYPE gjahr,
             transactioncode                TYPE tcode,
             accountingdocumenttype         TYPE blart,
             documentdate                   TYPE bldat,
             fiscalperiod                   TYPE monat,
             accountingdocumentcreationdate TYPE datum,
             creationtime                   TYPE uzeit,
             lastchangedate                 TYPE datum,
             accountingdoccreatedbyuser     TYPE usnam,
             reversedocument                TYPE belnr_d,
             reversedocumentfiscalyear      TYPE gjahr,
             exchangerate                   TYPE zetr_e_kursf,
             accountingdocumentcategory     TYPE c LENGTH 1,
             companycodecurrency            TYPE waers,
             transactioncurrency            TYPE waers,
             ledgergroup                    TYPE c LENGTH 4,
             reversalreason                 TYPE stgrd,
             accountingdocumentclass        TYPE c LENGTH 6,
             exchangeratetype               TYPE kurst,
             isreversaldocument             TYPE abap_boolean,
             postingdate                    TYPE budat,
             exchangeratedate               TYPE wwert_d,
             referencedocumenttype          TYPE fis_awtyp,
             referencedocumentlogicalsystem TYPE logsystem,
             originalreferencedocument      TYPE c LENGTH 20,
             accountingdocexternalreference TYPE xblnr1,
             accountingdocumentheadertext   TYPE bktxt,
             reference1indocumentheader     TYPE c LENGTH 20,
             reference2indocumentheader     TYPE c LENGTH 20,
           END OF mty_accdoc_header,

           BEGIN OF mty_accdoc_item_out,
             rowindex                      TYPE i,
             documentitemtext              TYPE sgtxt,
             reference1idbybusinesspartner TYPE c LENGTH 12,
             reference2idbybusinesspartner TYPE c LENGTH 12,
             reference3idbybusinesspartner TYPE c LENGTH 20,
             assignmentreference           TYPE dzuonr,
             einvoiceuuid                  TYPE sysuuid_c22,
           END OF mty_accdoc_item_out,
           mty_accdoc_items_out TYPE STANDARD TABLE OF mty_accdoc_item_out WITH EMPTY KEY,

           BEGIN OF mty_accdoc_item,
             accountingdocumentitem       TYPE buzei,
             postingkey                   TYPE bschl,
             financialaccounttype         TYPE koart,
             specialglcode                TYPE c LENGTH 1,
             debitcreditcode              TYPE shkzg,
             businessarea                 TYPE gsber,
             taxcode                      TYPE mwskz,
             withholdingtaxcode           TYPE c LENGTH 2,
             balancetransactioncurrency   TYPE waers,
             companycodecurrency          TYPE waers,
             paymentcurrency              TYPE waers,
             transactioncurrency          TYPE waers,
             amountinbalancetransaccrcy   TYPE fins_vwcur12,
             amountincompanycodecurrency  TYPE fins_vwcur12,
             amountintransactioncurrency  TYPE fins_vwcur12,
             amountinpaymentcurrency      TYPE fins_vwcur12,
             taxamountincocodecrcy        TYPE fins_vwcur12,
             taxamountintranscrcy         TYPE fins_vwcur12,
             taxbaseamountincocodecrcy    TYPE fins_vwcur12,
             taxbaseamountintranscrcy     TYPE fins_vwcur12,
             taxtype                      TYPE c LENGTH 1,
             transactiontypedetermination TYPE c LENGTH 3,
             withholdingtaxbaseamount     TYPE fins_vwcur12,
             costcenter                   TYPE kostl,
             billingdocument              TYPE sd_sls_document,
             salesdocument                TYPE sd_sls_document,
             salesdocumentitem            TYPE sd_sls_document_item,
             isautomaticallycreated       TYPE abap_boolean,
             alternativeglaccount         TYPE hkont,
             glaccount                    TYPE hkont,
             customer                     TYPE lifnr,
             supplier                     TYPE lifnr,
             duecalculationbasedate       TYPE dzfbdt,
             paymentterms                 TYPE dzterm,
             cashdiscount1days            TYPE dzbd1t,
             cashdiscount2days            TYPE dzbd2t,
             netpaymentdays               TYPE dzbd3t,
             withholdingtaxamount         TYPE fins_vwcur12,
             withholdingtaxexemptionamt   TYPE fins_vwcur12,
             material                     TYPE matnr,
             plant                        TYPE werks_d,
             quantity                     TYPE menge_d,
             baseunit                     TYPE meins,
             netduedate                   TYPE datum.
             INCLUDE TYPE mty_accdoc_item_out.
    TYPES: END OF mty_accdoc_item,
    mty_accdoc_items TYPE STANDARD TABLE OF mty_accdoc_item WITH EMPTY KEY.

    CLASS-METHODS fin_accdoc_validation
      IMPORTING
        !is_accountingdocheader TYPE mty_accdoc_header
        !it_accountingdocitems  TYPE mty_accdoc_items
      CHANGING
        !cs_validationmessage   TYPE symsg.

    CLASS-METHODS fin_acdoc_substitution
      IMPORTING
        !is_accountingdocheader   TYPE mty_accdoc_header
        !it_accountingdocitems    TYPE mty_accdoc_items
      CHANGING
        !cv_substitutiondone      TYPE abap_boolean
        !ct_accountingdocitemsout TYPE mty_accdoc_items_out
      RAISING
        cx_ble_runtime_error .
