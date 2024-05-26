CLASS lhc_InvoiceList DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR InvoiceList RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR InvoiceList RESULT result.

    METHODS addNote FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~addNote RESULT result.

    METHODS archiveInvoices FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~archiveInvoices RESULT result.

    METHODS changePrintStatus FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~changePrintStatus RESULT result.

    METHODS changeProcessStatus FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~changeProcessStatus RESULT result.

    METHODS statusUpdate FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~statusUpdate RESULT result.

    METHODS sendResponse FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~sendResponse RESULT result.

    METHODS setAsRejected FOR MODIFY
      IMPORTING keys FOR ACTION InvoiceList~setAsRejected RESULT result.

ENDCLASS.

CLASS lhc_InvoiceList IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY InvoiceList
            ALL FIELDS
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invoices)
        FAILED failed.
    CHECK lt_invoices IS NOT INITIAL.

    SELECT *
      FROM zetr_t_usaut
      FOR ALL ENTRIES IN @lt_invoices
      WHERE bukrs = @lt_invoices-CompanyCode
      INTO TABLE @DATA(lt_authorizations).

    result = VALUE #( FOR ls_invoice IN lt_invoices
                      ( %tky = ls_invoice-%tky
                        %field-PurchasingGroup = COND #( WHEN line_exists( lt_authorizations[ bukrs = ls_invoice-CompanyCode icipc = abap_true ] )
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %action-sendResponse = COND #( WHEN ls_invoice-ResponseStatus <> '0'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-setAsRejected = COND #( WHEN ls_invoice-ResponseStatus <> '0' AND ls_invoice-ResponseStatus <> 'X'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-archiveinvoices = COND #( WHEN ls_invoice-Processed = '' OR ls_invoice-Archived = abap_true
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-changeProcessStatus = COND #( WHEN ls_invoice-ResponseStatus = '0' OR ls_invoice-Archived = abap_true
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-statusupdate = COND #( WHEN ls_invoice-ResponseStatus <> '0'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD addNote.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0 AND ls_key-%param-Note IS NOT INITIAL.

    TRY.

        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FROM VALUE #( FOR key IN keys ( documentuuid = key-documentuuid
                                                    lastnote = ls_key-%param-note
                                                    lastnotecreatedby = sy-uname
                                                    %control-lastnote = if_abap_behv=>mk-on
                                                    %control-lastnotecreatedby = if_abap_behv=>mk-on  ) )
          ENTITY invoicelist
            CREATE BY \_invoicelogs
            FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
            AUTO FILL CID
            WITH VALUE #( FOR key IN keys
                             ( documentuuid = key-documentuuid
                               %target = VALUE #( ( loguuid = cl_system_uuid=>create_uuid_c22_static( )
                                                    documentuuid = key-documentuuid
                                                    createdby = sy-uname
                                                    creationdate = cl_abap_context_info=>get_system_date( )
                                                    creationtime = cl_abap_context_info=>get_system_time( )
                                                    LogCode = zcl_etr_regulative_log=>mc_log_codes-note_added
                                                    LogNote = ls_key-%param-Note ) ) )  )
            FAILED failed
            REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    result = VALUE #( FOR invoice IN invoices
             ( %tky   = invoice-%tky
               %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '082'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.
  ENDMETHOD.

  METHOD archiveInvoices.
    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    DATA lt_archive TYPE STANDARD TABLE OF zetr_t_arcd.
    SELECT docui, conty, docty
      FROM zetr_t_arcd
      FOR ALL ENTRIES IN @invoices
      WHERE docui = @invoices-DocumentUUID
      INTO CORRESPONDING FIELDS OF TABLE @lt_archive.

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<ls_invoice>).
      TRY.
          DATA(lo_einvoice_operations) = zcl_etr_invoice_operations=>factory( <ls_invoice>-companycode ).
          LOOP AT lt_archive ASSIGNING FIELD-SYMBOL(<ls_archive>).
            <ls_archive>-contn = lo_einvoice_operations->incoming_einvoice_download(
               EXPORTING
                 iv_document_uid = <ls_invoice>-DocumentUUID
                 iv_content_type = <ls_archive>-conty
                 iv_create_log   = abap_false ).
          ENDLOOP.
          <ls_invoice>-Archived = abap_true.
        CATCH zcx_etr_regulative_exception INTO DATA(lx_exception).
          DATA(lv_error) = CONV bapi_msg( lx_exception->get_text( ) ).
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '201'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = <ls_invoice>-DocumentUUID ) ) TO reported-invoicelist.
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '000'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = lv_error(50)
                                              v2 = lv_error+50(50)
                                              v3 = lv_error+100(50)
                                              v4 = lv_error+150(*) ) ) TO reported-invoicelist.
        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.
    ENDLOOP.
    DELETE lt_archive WHERE contn IS INITIAL.
    CHECK lt_archive IS NOT INITIAL.
    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FIELDS ( archived )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-DocumentUUID
                                                     archived = abap_true
                                                     %control-archived = if_abap_behv=>mk-on ) )
              ENTITY InvoiceContents
                UPDATE FIELDS ( Content )
                WITH VALUE #( FOR ls_archive IN lt_archive ( DocumentType = ls_archive-docty
                                                             DocumentUUID = ls_archive-docui
                                                             Content = ls_archive-contn
                                                             ContentType = ls_archive-conty
                                                             %control-Content = if_abap_behv=>mk-on ) )
             ENTITY invoicelist
                CREATE BY \_invoicelogs
                FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                AUTO FILL CID
                WITH VALUE #( FOR invoice IN invoices
                                 ( DocumentUUID = invoice-DocumentUUID
                                   %target = VALUE #( ( LogUUID = cl_system_uuid=>create_uuid_c22_static( )
                                                        DocumentUUID = invoice-DocumentUUID
                                                        CreatedBy = sy-uname
                                                        CreationDate = cl_abap_context_info=>get_system_date( )
                                                        CreationTime = cl_abap_context_info=>get_system_time( )
                                                        LogCode = zcl_etr_regulative_log=>mc_log_codes-archived ) ) )  )
             FAILED failed
             REPORTED reported.

      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT invoices.

    result = VALUE #( FOR invoice IN invoices
             ( %tky   = invoice-%tky
               %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '082'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.

  ENDMETHOD.

  METHOD changePrintStatus.
    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<invoice>).
      <invoice>-Printed = SWITCH #( <invoice>-Printed WHEN abap_false THEN abap_true ELSE abap_false ).
    ENDLOOP.

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FIELDS ( printed )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid
                                                     printed = invoice-printed
                                                     %control-printed = if_abap_behv=>mk-on ) )
              ENTITY invoicelist
                CREATE BY \_invoicelogs
                FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                AUTO FILL CID
                WITH VALUE #( FOR invoice IN invoices
                                 ( documentuuid = invoice-documentuuid
                                   %target = VALUE #( ( loguuid = cl_system_uuid=>create_uuid_c22_static( )
                                                        documentuuid = invoice-documentuuid
                                                        createdby = sy-uname
                                                        creationdate = cl_abap_context_info=>get_system_date( )
                                                        creationtime = cl_abap_context_info=>get_system_time( )
                                                        logcode = SWITCH #( invoice-Printed WHEN abap_true THEN zcl_etr_regulative_log=>mc_log_codes-printed ELSE zcl_etr_regulative_log=>mc_log_codes-nonprinted ) ) ) )  )
             FAILED failed
             REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT invoices.

    result = VALUE #( FOR invoice IN invoices
             ( %tky   = invoice-%tky
               %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '082'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.
  ENDMETHOD.

  METHOD changeProcessStatus.
    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<invoice>).
      <invoice>-Processed = SWITCH #( <invoice>-Processed WHEN abap_false THEN abap_true ELSE abap_false ).
    ENDLOOP.

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FIELDS ( processed )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid
                                                     processed = invoice-processed
                                                     %control-Processed = if_abap_behv=>mk-on ) )
                  ENTITY invoicelist
                    CREATE BY \_invoicelogs
                    FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                    AUTO FILL CID
                    WITH VALUE #( FOR invoice IN invoices
                                     ( documentuuid = invoice-documentuuid
                                       %target = VALUE #( ( loguuid = cl_system_uuid=>create_uuid_c22_static( )
                                                            documentuuid = invoice-documentuuid
                                                            createdby = sy-uname
                                                            creationdate = cl_abap_context_info=>get_system_date( )
                                                            creationtime = cl_abap_context_info=>get_system_time( )
                                                            logcode = SWITCH #( invoice-Processed WHEN abap_true THEN zcl_etr_regulative_log=>mc_log_codes-processed ELSE zcl_etr_regulative_log=>mc_log_codes-nonprocessed ) ) ) )  )
             FAILED failed
             REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT invoices.

    result = VALUE #( FOR invoice IN invoices
             ( %tky   = invoice-%tky
               %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '082'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.
  ENDMETHOD.

*  METHOD downloadInvoices.
*  ENDMETHOD.

  METHOD statusUpdate.
    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<ls_invoice>).
      TRY.
          DATA(lo_einvoice_service) = zcl_etr_einvoice_ws=>factory( <ls_invoice>-companycode ).
          DATA(ls_status) = lo_einvoice_service->incoming_invoice_get_status( VALUE #(  docui  = <ls_invoice>-DocumentUUID
                                                                                        docii  = <ls_invoice>-IntegratorUUID
                                                                                        duich  = <ls_invoice>-InvoiceUUID
                                                                                        docno  = <ls_invoice>-InvoiceID
                                                                                        envui  = <ls_invoice>-EnvelopeUUID ) ).
          <ls_invoice>-ResponseStatus = ls_status-resst.
          <ls_invoice>-TRAStatusCode = ls_status-radsc.
          <ls_invoice>-StatusDetail = ls_status-staex.
        CATCH zcx_etr_regulative_exception INTO DATA(lx_exception).
          DATA(lv_error) = CONV bapi_msg( lx_exception->get_text( ) ).
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '201'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = <ls_invoice>-DocumentUUID ) ) TO reported-invoicelist.
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '000'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = lv_error(50)
                                              v2 = lv_error+50(50)
                                              v3 = lv_error+100(50)
                                              v4 = lv_error+150(*) ) ) TO reported-invoicelist.
          DELETE invoices.
      ENDTRY.
    ENDLOOP.
    CHECK invoices IS NOT INITIAL.

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FIELDS ( ResponseStatus TRAStatusCode StatusDetail )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid
                                                     ResponseStatus = invoice-ResponseStatus
                                                     TRAStatusCode = invoice-TRAStatusCode
                                                     StatusDetail = invoice-StatusDetail
                                                     %control-ResponseStatus = if_abap_behv=>mk-on
                                                     %control-TRAStatusCode = if_abap_behv=>mk-on
                                                     %control-StatusDetail = if_abap_behv=>mk-on ) )
                  ENTITY invoicelist
                    CREATE BY \_invoicelogs
                    FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                    AUTO FILL CID
                    WITH VALUE #( FOR invoice IN invoices
                                     ( documentuuid = invoice-documentuuid
                                       %target = VALUE #( ( loguuid = cl_system_uuid=>create_uuid_c22_static( )
                                                            documentuuid = invoice-documentuuid
                                                            createdby = sy-uname
                                                            creationdate = cl_abap_context_info=>get_system_date( )
                                                            creationtime = cl_abap_context_info=>get_system_time( )
                                                            logcode = zcl_etr_regulative_log=>mc_log_codes-status ) ) ) )
             FAILED failed
             REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    result = VALUE #( FOR invoice IN invoices
                 ( %tky   = invoice-%tky
                   %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '003'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.

  ENDMETHOD.

  METHOD setAsRejected.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc <> 0 OR ls_key-%param-RejectNote IS INITIAL OR ls_key-%param-RejectType IS INITIAL.
      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                          number   = '202'
                                          severity = if_abap_behv_message=>severity-error ) ) TO reported-invoicelist.
      RETURN.
    ENDIF.

    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FIELDS ( ResponseStatus )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid
                                                     ResponseStatus = ls_key-%param-RejectType
                                                     %control-ResponseStatus = if_abap_behv=>mk-on ) )
                  ENTITY invoicelist
                    CREATE BY \_invoicelogs
                    FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                    AUTO FILL CID
                    WITH VALUE #( FOR invoice IN invoices
                                     ( documentuuid = invoice-documentuuid
                                       %target = VALUE #( ( loguuid = cl_system_uuid=>create_uuid_c22_static( )
                                                            documentuuid = invoice-documentuuid
                                                            createdby = sy-uname
                                                            creationdate = cl_abap_context_info=>get_system_date( )
                                                            creationtime = cl_abap_context_info=>get_system_time( )
                                                            lognote = ls_key-%param-RejectNote
                                                            logcode = SWITCH #( ls_key-%param-RejectType
                                                                        WHEN 'K' THEN zcl_etr_regulative_log=>mc_log_codes-rejected_via_kep
                                                                        WHEN 'G' THEN zcl_etr_regulative_log=>mc_log_codes-rejected_via_gib
                                                                        WHEN 'R' THEN zcl_etr_regulative_log=>mc_log_codes-set_as_rejected
                                                                        ELSE zcl_etr_regulative_log=>mc_log_codes-rejected ) ) ) )  )
             FAILED failed
             REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    result = VALUE #( FOR invoice IN invoices
                 ( %tky   = invoice-%tky
                   %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '003'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.

  ENDMETHOD.

  METHOD sendresponse.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc <> 0 OR ls_key-%param-ApplicationResponse IS INITIAL OR ls_key-%param-ResponseNote IS INITIAL.
      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                          number   = '202'
                                          severity = if_abap_behv_message=>severity-error ) ) TO reported-invoicelist.
      RETURN.
    ENDIF.

    READ ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
      ENTITY InvoiceList
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<ls_invoice>).
      TRY.
          DATA(lo_invoice_service) = zcl_etr_einvoice_ws=>factory( <ls_invoice>-CompanyCode ).
          lo_invoice_service->incoming_invoice_response( is_document_numbers = VALUE #( docui = <ls_invoice>-DocumentUUID
                                                                                        duich = <ls_invoice>-InvoiceUUID
                                                                                        docii = <ls_invoice>-IntegratorUUID
                                                                                        docno = <ls_invoice>-InvoiceID
                                                                                        envui = <ls_invoice>-EnvelopeUUID )
                                                         iv_application_response = ''
                                                         iv_receiver_alias   = <ls_invoice>-Aliass
                                                         iv_receiver_taxid   = <ls_invoice>-TaxID ).
          DATA(ls_status) = lo_invoice_service->incoming_invoice_get_status( VALUE #(  docui  = <ls_invoice>-DocumentUUID
                                                                                       docii  = <ls_invoice>-IntegratorUUID
                                                                                       duich  = <ls_invoice>-InvoiceUUID
                                                                                       docno  = <ls_invoice>-InvoiceID
                                                                                       envui  = <ls_invoice>-EnvelopeUUID ) ).
          <ls_invoice>-ResponseStatus = ls_status-resst.
          <ls_invoice>-TRAStatusCode = ls_status-radsc.
          <ls_invoice>-StatusDetail = ls_status-staex.
        CATCH zcx_etr_regulative_exception INTO DATA(lx_regulative_exception).
          DATA(lv_error) = CONV bapi_msg( lx_regulative_exception->get_text( ) ).
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '201'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = <ls_invoice>-DocumentUUID ) ) TO reported-invoicelist.
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '000'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = lv_error(50)
                                              v2 = lv_error+50(50)
                                              v3 = lv_error+100(50)
                                              v4 = lv_error+150(*) ) ) TO reported-invoicelist.
          DELETE invoices.
      ENDTRY.
    ENDLOOP.

    CHECK invoices IS NOT INITIAL.

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_incoming_invoices IN LOCAL MODE
          ENTITY invoicelist
             UPDATE FIELDS ( ResponseStatus TRAStatusCode StatusDetail )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid
                                                     ResponseStatus = invoice-ResponseStatus
                                                     TRAStatusCode = invoice-TRAStatusCode
                                                     StatusDetail = invoice-StatusDetail
                                                     %control-ResponseStatus = if_abap_behv=>mk-on
                                                     %control-TRAStatusCode = if_abap_behv=>mk-on
                                                     %control-StatusDetail = if_abap_behv=>mk-on ) )
                  ENTITY invoicelist
                    CREATE BY \_invoicelogs
                    FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                    AUTO FILL CID
                    WITH VALUE #( FOR invoice IN invoices
                                     ( documentuuid = invoice-documentuuid
                                       %target = VALUE #( ( loguuid = cl_system_uuid=>create_uuid_c22_static( )
                                                            documentuuid = invoice-documentuuid
                                                            createdby = sy-uname
                                                            creationdate = cl_abap_context_info=>get_system_date( )
                                                            creationtime = cl_abap_context_info=>get_system_time( )
                                                            lognote = ls_key-%param-ApplicationResponse
                                                            logcode = SWITCH #( ls_key-%param-ApplicationResponse
                                                                        WHEN 'KABUL' THEN zcl_etr_regulative_log=>mc_log_codes-accepted
                                                                        WHEN 'RED' THEN zcl_etr_regulative_log=>mc_log_codes-rejected
                                                                        ELSE zcl_etr_regulative_log=>mc_log_codes-response ) ) ) ) )
             FAILED failed
             REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    result = VALUE #( FOR invoice IN invoices
                 ( %tky   = invoice-%tky
                   %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '003'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-invoicelist.


  ENDMETHOD.

ENDCLASS.