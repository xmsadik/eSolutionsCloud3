CLASS lhc_zetr_ddl_i_outgoing_invoic DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR outgoinginvoices RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR outgoinginvoices RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR outgoinginvoices RESULT result.

    METHODS archiveinvoices FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~archiveinvoices RESULT result.

    METHODS sendinvoices FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~sendinvoices RESULT result.

    METHODS setasrejected FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~setasrejected RESULT result.

    METHODS statusupdate FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~statusupdate RESULT result.


ENDCLASS.

CLASS lhc_zetr_ddl_i_outgoing_invoic IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
          ENTITY outgoinginvoices
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
                        %action-sendinvoices = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-archiveinvoices = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-setasrejected = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-statusupdate = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %features-%update = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %features-%delete = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %field-profileid = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-mandatory  )
                        %field-internetsale = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-TransportType = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'IHRACAT'
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-invoicenote = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-StatusCode = COND #( WHEN line_exists( lt_authorizations[ bukrs = ls_invoice-CompanyCode ogisc = abap_true ] )
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-StatusDetail = COND #( WHEN line_exists( lt_authorizations[ bukrs = ls_invoice-CompanyCode ogisc = abap_true ] )
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-TRAStatusCode = COND #( WHEN line_exists( lt_authorizations[ bukrs = ls_invoice-CompanyCode ogisc = abap_true ] )
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-Response = COND #( WHEN line_exists( lt_authorizations[ bukrs = ls_invoice-CompanyCode ogisc = abap_true ] )
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-invoicetype = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-taxtype = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-taxexemption = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-collectitems = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-serialprefix = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-xslttemplate = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-earchivetype = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-aliass = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                      ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD archiveinvoices.
    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
    ENTITY outgoinginvoices
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
          IF <ls_invoice>-Response = '0'.
            APPEND VALUE #( documentuuid = <ls_invoice>-DocumentUUID
                            %msg = new_message( id = 'ZETR_COMMON'
                                                number = '008'
                                                severity = if_abap_behv_message=>severity-error ) ) TO reported-outgoinginvoices.
          ELSEIF <ls_invoice>-Archived = abap_true.
            APPEND VALUE #( documentuuid = <ls_invoice>-DocumentUUID
                            %msg = new_message( id = 'ZETR_COMMON'
                                                number = '042'
                                                severity = if_abap_behv_message=>severity-error ) ) TO reported-outgoinginvoices.
          ELSEIF <ls_invoice>-StatusCode = '' OR
                 <ls_invoice>-StatusCode = '2'.
            APPEND VALUE #( documentuuid = <ls_invoice>-DocumentUUID
                            %msg = new_message( id = 'ZETR_COMMON'
                                                number = '032'
                                                severity = if_abap_behv_message=>severity-error ) ) TO reported-outgoinginvoices.
          ELSE.
            DATA(lo_einvoice_operations) = zcl_etr_invoice_operations=>factory( <ls_invoice>-companycode ).
            LOOP AT lt_archive ASSIGNING FIELD-SYMBOL(<ls_archive>).
              <ls_archive>-contn = lo_einvoice_operations->outgoing_invoice_download(
                 EXPORTING
                   iv_document_uid = <ls_invoice>-DocumentUUID
                   iv_content_type = <ls_archive>-conty
                   iv_create_log   = abap_false ).
            ENDLOOP.
            <ls_invoice>-Archived = abap_true.
          ENDIF.
        CATCH zcx_etr_regulative_exception INTO DATA(lx_exception).
          DATA(lv_error) = CONV bapi_msg( lx_exception->get_text( ) ).
          APPEND VALUE #( documentuuid = <ls_invoice>-DocumentUUID
                          %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '000'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = lv_error(50)
                                              v2 = lv_error+50(50)
                                              v3 = lv_error+100(50)
                                              v4 = lv_error+150(*) ) ) TO reported-outgoinginvoices.
        CATCH cx_uuid_error.
      ENDTRY.
    ENDLOOP.
    DELETE lt_archive WHERE contn IS INITIAL.
    CHECK lt_archive IS NOT INITIAL.
    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
          ENTITY outgoinginvoices
             UPDATE FIELDS ( archived )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-DocumentUUID
                                                     archived = abap_true
                                                     %control-archived = if_abap_behv=>mk-on ) )
              ENTITY InvoiceContents
                UPDATE FIELDS ( Content )
                WITH VALUE #( FOR ls_archive IN lt_archive ( DocumentUUID = ls_archive-docui
                                                             DocumentType = ls_archive-docty
                                                             Content = ls_archive-contn
                                                             ContentType = ls_archive-conty
                                                             %control-Content = if_abap_behv=>mk-on ) )
             ENTITY outgoinginvoices
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

    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY outgoinginvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT invoices.

    result = VALUE #( FOR invoice IN invoices
             ( %tky   = invoice-%tky
               %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '082'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-outgoinginvoices.

  ENDMETHOD.

  METHOD sendinvoices.
    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY OutgoingInvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(InvoiceList).
    SORT InvoiceList BY CompanyCode ProfileID DocumentDate DocumentNumber.

    IF line_exists( InvoiceList[ ProfileID = 'IHRACAT' ] ).
      SELECT SINGLE TaxID
        FROM zetr_ddl_i_other_partner
        WHERE PartnerType = 'C'
        INTO @DATA(CustomsOfficeTaxID).
      IF sy-subrc = 0.
        SELECT aliass
          FROM zetr_t_inv_ruser
          WHERE taxid = @CustomsOfficeTaxID
          ORDER BY defal DESCENDING
          INTO @DATA(CustomsOfficeAlias)
          UP TO 1 ROWS.
        ENDSELECT.
      ENDIF.
    ENDIF.

    LOOP AT InvoiceList ASSIGNING FIELD-SYMBOL(<InvoiceLine>).
      IF <InvoiceLine>-Reversed = abap_true.
        APPEND VALUE #( DocumentUUID = <InvoiceLine>-DocumentUUID
                        %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '036'
                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-OutgoingInvoices.
        DELETE InvoiceList.
      ELSEIF ( <InvoiceLine>-TaxAmount IS INITIAL OR <InvoiceLine>-ExemptionExists = abap_true ) AND <InvoiceLine>-TaxExemption IS INITIAL.
        APPEND VALUE #( DocumentUUID = <InvoiceLine>-DocumentUUID
                        %msg = new_message( id       = 'ZETR_COMMON'
                                            number   = '039'
                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-OutgoingInvoices.
        DELETE InvoiceList.
      ELSE.
        TRY.
            DATA(OutgoingInvoiceInstance) = zcl_etr_outgoing_invoice=>factory( <invoiceline>-documentuuid ).
            IF <InvoiceLine>-InvoiceID IS INITIAL.
              <InvoiceLine>-InvoiceID = OutgoingInvoiceInstance->generate_invoice_id( iv_save_db = '' ).
            ENDIF.
            OutgoingInvoiceInstance->build_invoice_data(
              IMPORTING
                es_invoice_ubl       = DATA(ls_invoice_ubl)
                ev_invoice_ubl       = DATA(lv_invoice_ubl)
                ev_invoice_hash      = DATA(lv_invoice_hash)
                et_custom_parameters = DATA(lt_custom_parameters) ).
            DATA(PartyTaxID) = SWITCH zetr_e_taxid( <InvoiceLine>-ProfileID WHEN 'IHRACAT' THEN CustomsOfficeTaxID ELSE <InvoiceLine>-TaxID ).
            DATA(PartyAlias) = SWITCH zetr_e_alias( <InvoiceLine>-ProfileID WHEN 'IHRACAT' THEN CustomsOfficeAlias ELSE <InvoiceLine>-Aliass ).
            CASE <InvoiceLine>-ProfileID.
              WHEN 'EARSIV'.
                DATA(eArchiveServiceInstance) = zcl_etr_earchive_ws=>factory( <InvoiceLine>-CompanyCode ).
                eArchiveServiceInstance->outgoing_invoice_send(
                  EXPORTING
                    iv_document_uuid     = <InvoiceLine>-DocumentUUID
                    is_ubl_structure     = ls_invoice_ubl
                    iv_ubl_xstring       = lv_invoice_ubl
                    iv_ubl_hash          = lv_invoice_hash
                    iv_receiver_alias    = PartyAlias
                    iv_receiver_taxid    = PartyTaxID
                    iv_earchive_type     = <InvoiceLine>-eArchiveType
                    iv_internet_sale     = <InvoiceLine>-InternetSale
                    it_custom_parameters = lt_custom_parameters
                  IMPORTING
                    ev_integrator_uuid   = <InvoiceLine>-IntegratorDocumentID
                    ev_invoice_uuid      = DATA(lv_invoice_uuid)
                    ev_invoice_no        = DATA(lv_invoice_no)
                    ev_envelope_uuid     = DATA(lv_envelope_uuid)
                    es_status            = DATA(ls_ea_status) ).
              WHEN OTHERS.
                DATA(eInvoiceServiceInstance) = zcl_etr_einvoice_ws=>factory( <InvoiceLine>-CompanyCode ).
                eInvoiceServiceInstance->outgoing_invoice_send(
                  EXPORTING
                    iv_document_uuid     = <InvoiceLine>-DocumentUUID
                    is_ubl_structure     = ls_invoice_ubl
                    iv_ubl_xstring       = lv_invoice_ubl
                    iv_ubl_hash          = lv_invoice_hash
                    iv_receiver_alias    = PartyAlias
                    iv_receiver_taxid    = PartyTaxID
                    it_custom_parameters = lt_custom_parameters
                  IMPORTING
                    ev_integrator_uuid   = <InvoiceLine>-IntegratorDocumentID
                    ev_invoice_uuid      = lv_invoice_uuid
                    ev_invoice_no        = lv_invoice_no
                    ev_envelope_uuid     = lv_envelope_uuid
                    es_status            = DATA(ls_ei_status) ).
            ENDCASE.
            IF lv_invoice_uuid IS NOT INITIAL.
              <InvoiceLine>-InvoiceUUID = lv_invoice_uuid.
            ENDIF.
            IF lv_invoice_no IS NOT INITIAL.
              <InvoiceLine>-InvoiceID = lv_invoice_no.
            ENDIF.
            IF lv_envelope_uuid IS NOT INITIAL.
              <InvoiceLine>-EnvelopeUUID = lv_envelope_uuid.
            ENDIF.

            CASE <InvoiceLine>-ProfileID.
              WHEN 'EARSIV'.
                <InvoiceLine>-StatusCode = ls_ea_status-stacd.
                <InvoiceLine>-Response = 'X'.
              WHEN OTHERS.
                <InvoiceLine>-StatusCode = ls_ei_status-stacd.
                <InvoiceLine>-StatusDetail = ls_ei_status-staex.
                <InvoiceLine>-Response = ls_ei_status-resst.
            ENDCASE.
            <InvoiceLine>-Printed = ''.
            <InvoiceLine>-Sender = sy-uname.
            <InvoiceLine>-SendDate = cl_abap_context_info=>get_system_date( ).
            <InvoiceLine>-SendTime = cl_abap_context_info=>get_system_time( ).

            APPEND VALUE #( DocumentUUID = <InvoiceLine>-DocumentUUID
                            %msg = new_message( id       = 'ZETR_COMMON'
                                                number   = '033'
                                                severity = if_abap_behv_message=>severity-success ) ) TO reported-OutgoingInvoices.


          CATCH cx_root INTO DATA(RegulativeException).
            DATA(ErrorMessage) = CONV bapi_msg( RegulativeException->get_text( ) ).
            APPEND VALUE #( DocumentUUID = <InvoiceLine>-DocumentUUID
                            %msg = new_message( id       = 'ZETR_COMMON'
                                                number   = '207'
                                                severity = if_abap_behv_message=>severity-information ) ) TO reported-OutgoingInvoices.
            APPEND VALUE #( DocumentUUID = <InvoiceLine>-DocumentUUID
                            %msg = new_message( id       = 'ZETR_COMMON'
                                                number   = '000'
                                                severity = if_abap_behv_message=>severity-information
                                                v1 = ErrorMessage(50)
                                                v2 = ErrorMessage+50(50)
                                                v3 = ErrorMessage+100(50)
                                                v4 = ErrorMessage+150(*) ) ) TO reported-OutgoingInvoices.
            <InvoiceLine>-StatusCode = '2'.
            <InvoiceLine>-StatusDetail = ErrorMessage.
            EXIT.
        ENDTRY.
      ENDIF.
    ENDLOOP.
    CHECK InvoiceList IS NOT INITIAL.

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
          ENTITY OutgoingInvoices
             UPDATE FIELDS ( Sender SendDate SendTime Printed InvoiceUUID InvoiceID IntegratorDocumentID EnvelopeUUID StatusCode Response )
             WITH VALUE #( FOR Invoice IN InvoiceList ( DocumentUUID = Invoice-DocumentUUID
                                                        Sender = Invoice-Sender
                                                        SendDate = Invoice-SendDate
                                                        SendTime = Invoice-SendTime
                                                        Printed = Invoice-Printed
                                                        InvoiceUUID = Invoice-InvoiceUUID
                                                        InvoiceID = Invoice-InvoiceID
                                                        IntegratorDocumentID = Invoice-IntegratorDocumentID
                                                        EnvelopeUUID = Invoice-EnvelopeUUID
                                                        StatusCode = Invoice-StatusCode
                                                        StatusDetail = Invoice-StatusDetail
                                                        Response = Invoice-Response
                                                        %control-Sender = if_abap_behv=>mk-on
                                                        %control-SendDate = if_abap_behv=>mk-on
                                                        %control-SendTime = if_abap_behv=>mk-on
                                                        %control-Printed = if_abap_behv=>mk-on
                                                        %control-InvoiceUUID = if_abap_behv=>mk-on
                                                        %control-InvoiceID = if_abap_behv=>mk-on
                                                        %control-IntegratorDocumentID = if_abap_behv=>mk-on
                                                        %control-EnvelopeUUID = if_abap_behv=>mk-on
                                                        %control-StatusCode = if_abap_behv=>mk-on
                                                        %control-StatusDetail = if_abap_behv=>mk-on
                                                        %control-Response = if_abap_behv=>mk-on ) )

*                ENTITY OutgoingInvoices
*                    CREATE BY \_invoiceContents
*                    FIELDS ( DocumentUUID ContentType DocumentType )
*                    AUTO FILL CID
*                    WITH VALUE #( FOR Invoice IN InvoiceList WHERE ( StatusCode <> '' AND StatusCode <> '2' )
*                                     ( DocumentUUID = Invoice-DocumentUUID
*                                       %target = VALUE #( ( DocumentType = 'OUTINVDOC'
*                                                            DocumentUUID = Invoice-DocumentUUID
*                                                            ContentType = 'PDF' )
*                                                          ( DocumentType = 'OUTINVDOC'
*                                                            DocumentUUID = Invoice-DocumentUUID
*                                                            ContentType = 'HTML' )
*                                                          ( DocumentType = 'OUTINVDOC'
*                                                            DocumentUUID = Invoice-DocumentUUID
*                                                            ContentType = 'UBL' ) ) ) )

                  ENTITY OutgoingInvoices
                    CREATE BY \_invoiceLogs
                    FIELDS ( loguuid documentuuid createdby creationdate creationtime logcode lognote )
                    AUTO FILL CID
                    WITH VALUE #( FOR Invoice IN InvoiceList WHERE ( StatusCode <> '' AND StatusCode <> '2' )
                                     ( DocumentUUID = Invoice-DocumentUUID
                                       %target = VALUE #( ( LogUUID = cl_system_uuid=>create_uuid_c22_static( )
                                                            DocumentUUID = Invoice-DocumentUUID
                                                            CreatedBy = sy-uname
                                                            CreationDate = cl_abap_context_info=>get_system_date( )
                                                            CreationTime = cl_abap_context_info=>get_system_time( )
                                                            LogCode = zcl_etr_regulative_log=>mc_log_codes-sent ) ) ) )
             FAILED failed.
*             REPORTED reported.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY OutgoingInvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT InvoiceList.
    result = VALUE #( FOR Invoice IN InvoiceList ( %tky   = invoice-%tky
                                                   %param = Invoice ) ).
  ENDMETHOD.

  METHOD setasrejected.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc <> 0 OR ls_key-%param-RejectNote IS INITIAL OR ls_key-%param-RejectType IS INITIAL.
      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                          number   = '202'
                                          severity = if_abap_behv_message=>severity-error ) ) TO reported-outgoinginvoices.
      RETURN.
    ENDIF.

    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY OutgoingInvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).

    TRY.
        MODIFY ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
          ENTITY OutgoingInvoices
             UPDATE FIELDS ( Response )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid
                                                     Response = ls_key-%param-RejectType
                                                     %control-Response = if_abap_behv=>mk-on ) )
                  ENTITY OutgoingInvoices
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

    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY OutgoingInvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT Invoices.
    result = VALUE #( FOR invoice IN invoices
                 ( %tky   = invoice-%tky
                   %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '003'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-OutgoingInvoices.

  ENDMETHOD.

  METHOD statusupdate.
    DATA lt_journal_entry TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change.

    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY outgoinginvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invoices).
    IF line_exists( invoices[ InvoiceIDSaved = '' ] ).
      SELECT ReferenceDocumentType AS awtyp,
             OriginalReferenceDocument AS awkey,
             companycode AS bukrs,
             accountingdocument AS belnr,
             fiscalyear AS gjahr,
             DocumentReferenceID AS xblnr
         FROM i_journalentry
         FOR ALL ENTRIES IN @invoices
         WHERE ReferenceDocumentType = @invoices-DocumentType
           AND OriginalReferenceDocument = @invoices-AwkeyInternal
           AND IsReversed = ''
           AND ReverseDocument = ''
         INTO TABLE @DATA(lt_fin_docs).
      SORT lt_fin_docs BY awtyp awkey.
    ENDIF.

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<ls_invoice>).
      TRY.
          DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( <ls_invoice>-companycode ).
          DATA(ls_status) = lo_invoice_operations->outgoing_invoice_status( iv_document_uid = <ls_invoice>-DocumentUUID
                                                                            iv_db_write = '' ).
          <ls_invoice>-StatusCode = ls_status-stacd.
          <ls_invoice>-StatusDetail = ls_status-staex.
          <ls_invoice>-Response = ls_status-resst.
          <ls_invoice>-TRAStatusCode = ls_status-radsc.
          <ls_invoice>-Resendable = ls_status-rsend.
          <ls_invoice>-ActualExportDate = ls_status-raded.
          <ls_invoice>-CustomsDocumentNo = ls_status-cedrn.
          <ls_invoice>-CustomsReferenceNo = ls_status-radrn.
          <ls_invoice>-EnvelopeUUID = ls_status-envui.
          <ls_invoice>-InvoiceUUID = ls_status-invui.
          <ls_invoice>-InvoiceID = ls_status-invno.
          <ls_invoice>-IntegratorDocumentID = ls_status-invii.
          <ls_invoice>-ReportID = ls_status-rprid.
          IF <ls_invoice>-InvoiceID IS NOT INITIAL AND <ls_invoice>-InvoiceIDSaved = abap_false AND
             <ls_invoice>-StatusCode <> '' AND <ls_invoice>-StatusCode <> '2'.
            IF <ls_invoice>-DocumentType <> 'BKPF'.
              READ TABLE lt_fin_docs
                INTO DATA(ls_fin_doc)
                WITH KEY awtyp = <ls_invoice>-DocumentType
                         awkey = <ls_invoice>-AwkeyInternal
                BINARY SEARCH.
              CHECK sy-subrc = 0.
            ELSE.
              ls_fin_doc-bukrs = <ls_invoice>-CompanyCode.
              ls_fin_doc-belnr = <ls_invoice>-DocumentNumber.
              ls_fin_doc-gjahr = <ls_invoice>-FiscalYear.
            ENDIF.
            APPEND INITIAL LINE TO lt_journal_entry ASSIGNING FIELD-SYMBOL(<ls_journal_entry>).
            <ls_journal_entry>-AccountingDocument = ls_fin_doc-belnr.
            <ls_journal_entry>-CompanyCode = ls_fin_doc-bukrs.
            <ls_journal_entry>-FiscalYear = ls_fin_doc-gjahr.
            <ls_journal_entry>-%param-DocumentReferenceID = <ls_invoice>-InvoiceID.
            <ls_journal_entry>-%param-%control-documentreferenceid = if_abap_behv=>mk-on.

            <ls_invoice>-InvoiceIDSaved = abap_true.
          ENDIF.

        CATCH zcx_etr_regulative_exception INTO DATA(lx_exception).
          DATA(lv_error) = CONV bapi_msg( lx_exception->get_text( ) ).
          APPEND VALUE #( DocumentUUID = <ls_invoice>-DocumentUUID
                          %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '000'
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = lv_error(50)
                                              v2 = lv_error+50(50)
                                              v3 = lv_error+100(50)
                                              v4 = lv_error+150(*) ) ) TO reported-outgoinginvoices.
          DELETE invoices.
      ENDTRY.
    ENDLOOP.
    CHECK invoices IS NOT INITIAL.

    TRY.
        IF lt_journal_entry IS NOT INITIAL.
          MODIFY ENTITIES OF i_journalentrytp
           ENTITY journalentry
           EXECUTE change FROM lt_journal_entry
           FAILED DATA(ls_failed)
           REPORTED DATA(ls_reported)
           MAPPED DATA(ls_mapped).
          IF ls_failed IS NOT INITIAL.
            SORT lt_fin_docs BY bukrs belnr gjahr.
            LOOP AT ls_failed-journalentry INTO DATA(ls_journal_failed).
              READ TABLE lt_fin_docs INTO ls_fin_doc
                WITH KEY bukrs = ls_journal_failed-CompanyCode
                         belnr = ls_journal_failed-AccountingDocument
                         gjahr = ls_journal_failed-FiscalYear
                BINARY SEARCH.
              IF sy-subrc = 0.
                CASE ls_fin_doc-awtyp(4).
                  WHEN 'BKPF'.
                    READ TABLE invoices
                      ASSIGNING <ls_invoice>
                      WITH KEY CompanyCode = ls_fin_doc-bukrs
                               DocumentNumber = ls_fin_doc-belnr
                               FiscalYear = ls_fin_doc-gjahr.
                  WHEN OTHERS.
                    READ TABLE invoices
                      ASSIGNING <ls_invoice>
                      WITH KEY DocumentType = ls_fin_doc-awtyp
                               AwkeyInternal = ls_fin_doc-awkey.
                ENDCASE.
                CHECK sy-subrc = 0.
                <ls_invoice>-InvoiceIDSaved = abap_false.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.

        MODIFY ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
          ENTITY outgoinginvoices
             UPDATE FIELDS ( StatusCode StatusDetail Response TRAStatusCode
                             Resendable ActualExportDate CustomsDocumentNo
                             CustomsReferenceNo EnvelopeUUID InvoiceUUID
                             InvoiceID IntegratorDocumentID ReportID InvoiceIDSaved )
             WITH VALUE #( FOR invoice IN invoices ( documentuuid = invoice-documentuuid

                                                     StatusCode = invoice-StatusCode
                                                     StatusDetail = invoice-StatusDetail
                                                     Response = invoice-Response
                                                     TRAStatusCode = invoice-TRAStatusCode
                                                     Resendable = invoice-Resendable
                                                     ActualExportDate = invoice-ActualExportDate
                                                     CustomsDocumentNo = invoice-CustomsDocumentNo
                                                     CustomsReferenceNo = invoice-CustomsReferenceNo
                                                     EnvelopeUUID = invoice-EnvelopeUUID
                                                     InvoiceUUID = invoice-InvoiceUUID
                                                     InvoiceID = invoice-InvoiceID
                                                     InvoiceIDSaved = invoice-InvoiceIDSaved
                                                     IntegratorDocumentID = invoice-IntegratorDocumentID
                                                     ReportID = invoice-ReportID

                                                     %control-StatusCode = if_abap_behv=>mk-on
                                                     %control-StatusDetail = if_abap_behv=>mk-on
                                                     %control-Response = if_abap_behv=>mk-on
                                                     %control-TRAStatusCode = if_abap_behv=>mk-on
                                                     %control-Resendable = if_abap_behv=>mk-on
                                                     %control-ActualExportDate = if_abap_behv=>mk-on
                                                     %control-CustomsDocumentNo = if_abap_behv=>mk-on
                                                     %control-CustomsReferenceNo = if_abap_behv=>mk-on
                                                     %control-EnvelopeUUID = if_abap_behv=>mk-on
                                                     %control-InvoiceUUID = if_abap_behv=>mk-on
                                                     %control-InvoiceID = if_abap_behv=>mk-on
                                                     %control-InvoiceIDSaved = if_abap_behv=>mk-on
                                                     %control-IntegratorDocumentID = if_abap_behv=>mk-on
                                                     %control-ReportID = if_abap_behv=>mk-on ) )
                  ENTITY outgoinginvoices
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

    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
      ENTITY OutgoingInvoices
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT Invoices.
    result = VALUE #( FOR invoice IN invoices
                 ( %tky   = invoice-%tky
                   %param = invoice ) ).

    APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                        number   = '003'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-outgoinginvoices.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_outgoing_invoic DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zetr_ddl_i_outgoing_invoic IMPLEMENTATION.

  METHOD save_modified.
    IF delete-outgoinginvoices IS NOT INITIAL.
      DATA lt_oginv TYPE TABLE OF zetr_t_oginv.
      lt_oginv = CORRESPONDING #( delete-outgoinginvoices MAPPING docui = DocumentUUID ).
      DELETE zetr_t_oginv FROM TABLE @lt_oginv.
    ENDIF.
    IF delete-invoicecontents IS NOT INITIAL.
      DATA lt_arcd TYPE TABLE OF zetr_t_arcd.
      lt_arcd = CORRESPONDING #( delete-invoicecontents MAPPING docui = DocumentUUID
                                                                docty = DocumentType
                                                                conty = ContentType ).
      DELETE zetr_t_arcd FROM TABLE @lt_arcd.
    ENDIF.

    IF update-outgoinginvoices IS NOT INITIAL.
      SELECT *
        FROM zetr_t_oginv
        FOR ALL ENTRIES IN @update-outgoinginvoices
        WHERE docui = @update-outgoinginvoices-documentuuid
        INTO TABLE @DATA(lt_invoices).
      SORT lt_invoices BY docui.

      DATA lt_logs TYPE zetr_tt_log_data.
      LOOP AT update-outgoinginvoices INTO DATA(ls_update).
        READ TABLE lt_invoices ASSIGNING FIELD-SYMBOL(<ls_invoice>) WITH KEY docui = ls_update-documentuuid BINARY SEARCH.
        CHECK sy-subrc = 0.
        IF ls_update-%control-aliass = if_abap_behv=>mk-on.
          <ls_invoice>-aliass = ls_update-aliass.
        ENDIF.
        IF ls_update-%control-profileid = if_abap_behv=>mk-on.
          <ls_invoice>-prfid = ls_update-profileid.
        ENDIF.
        IF ls_update-%control-invoicetype = if_abap_behv=>mk-on.
          <ls_invoice>-invty = ls_update-invoicetype.
        ENDIF.
        IF ls_update-%control-taxtype = if_abap_behv=>mk-on.
          <ls_invoice>-taxty = ls_update-taxtype.
        ENDIF.
        IF ls_update-%control-serialprefix = if_abap_behv=>mk-on.
          <ls_invoice>-serpr = ls_update-serialprefix.
        ENDIF.
        IF ls_update-%control-xslttemplate = if_abap_behv=>mk-on.
          <ls_invoice>-xsltt = ls_update-xslttemplate.
        ENDIF.
        IF ls_update-%control-taxexemption = if_abap_behv=>mk-on.
          <ls_invoice>-taxex = ls_update-taxexemption.
        ENDIF.
        IF ls_update-%control-printed = if_abap_behv=>mk-on.
          <ls_invoice>-prntd = ls_update-printed.
        ENDIF.
        IF ls_update-%control-collectitems = if_abap_behv=>mk-on.
          <ls_invoice>-itmcl = ls_update-collectitems.
        ENDIF.
        IF ls_update-%control-earchivetype = if_abap_behv=>mk-on.
          <ls_invoice>-eatyp = ls_update-earchivetype.
        ENDIF.
        IF ls_update-%control-internetsale = if_abap_behv=>mk-on.
          <ls_invoice>-intsl = ls_update-internetsale.
        ENDIF.
        IF ls_update-%control-invoicenote = if_abap_behv=>mk-on.
          <ls_invoice>-inote = ls_update-invoicenote.
        ENDIF.
        IF ls_update-%control-Sender = if_abap_behv=>mk-on.
          <ls_invoice>-sndus = ls_update-Sender.
        ENDIF.
        IF ls_update-%control-SendDate = if_abap_behv=>mk-on.
          <ls_invoice>-snddt = ls_update-SendDate.
        ENDIF.
        IF ls_update-%control-SendTime = if_abap_behv=>mk-on.
          <ls_invoice>-sndtm = ls_update-SendTime.
        ENDIF.
        IF ls_update-%control-InvoiceUUID = if_abap_behv=>mk-on.
          <ls_invoice>-invui = ls_update-InvoiceUUID.
        ENDIF.
        IF ls_update-%control-InvoiceID = if_abap_behv=>mk-on.
          <ls_invoice>-invno = ls_update-InvoiceID.
        ENDIF.
        IF ls_update-%control-InvoiceIDSaved = if_abap_behv=>mk-on.
          <ls_invoice>-inids = ls_update-InvoiceIDSaved.
        ENDIF.
        IF ls_update-%control-IntegratorDocumentID = if_abap_behv=>mk-on.
          <ls_invoice>-invii = ls_update-IntegratorDocumentID.
        ENDIF.
        IF ls_update-%control-EnvelopeUUID = if_abap_behv=>mk-on.
          <ls_invoice>-envui = ls_update-EnvelopeUUID.
        ENDIF.
        IF ls_update-%control-StatusCode = if_abap_behv=>mk-on.
          <ls_invoice>-stacd = ls_update-StatusCode.
        ENDIF.
        IF ls_update-%control-StatusDetail = if_abap_behv=>mk-on.
          <ls_invoice>-staex = ls_update-StatusDetail.
        ENDIF.
        IF ls_update-%control-Response = if_abap_behv=>mk-on.
          <ls_invoice>-resst = ls_update-Response.
        ENDIF.
        IF ls_update-%control-TRAStatusCode = if_abap_behv=>mk-on.
          <ls_invoice>-radsc = ls_update-TRAStatusCode.
        ENDIF.
        IF ls_update-%control-TransportType = if_abap_behv=>mk-on.
          <ls_invoice>-trnsp = ls_update-TransportType.
        ENDIF.
        IF ls_update-%control-Resendable = if_abap_behv=>mk-on.
          <ls_invoice>-rsend = ls_update-Resendable.
        ENDIF.
        IF ls_update-%control-ActualExportDate = if_abap_behv=>mk-on.
          <ls_invoice>-raded = ls_update-ActualExportDate.
        ENDIF.
        IF ls_update-%control-CustomsDocumentNo = if_abap_behv=>mk-on.
          <ls_invoice>-cedrn = ls_update-CustomsDocumentNo.
        ENDIF.
        IF ls_update-%control-CustomsReferenceNo = if_abap_behv=>mk-on.
          <ls_invoice>-radrn = ls_update-CustomsReferenceNo.
        ENDIF.
        IF ls_update-%control-ReportID = if_abap_behv=>mk-on.
          <ls_invoice>-rprid = ls_update-ReportID.
        ENDIF.
        APPEND INITIAL LINE TO lt_logs ASSIGNING FIELD-SYMBOL(<ls_log>).
        <ls_log>-docui = ls_update-documentuuid.
        <ls_log>-logcd = zcl_etr_regulative_log=>mc_log_codes-updated.
        <ls_log>-uname = sy-uname.
        GET TIME STAMP FIELD DATA(lv_timestamp).
        CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE <ls_log>-datum TIME <ls_log>-uzeit.
      ENDLOOP.
      MODIFY zetr_t_oginv FROM TABLE @lt_invoices.
      zcl_etr_regulative_log=>create( lt_logs ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.