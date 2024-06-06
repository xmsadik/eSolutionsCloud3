  METHOD if_rap_query_provider~select.
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA: lt_bukrs_range         TYPE RANGE OF bukrs,
              lt_belnr_range         TYPE RANGE OF belnr_d,
              lt_gjahr_range         TYPE RANGE OF gjahr,
              lt_awtyp_range         TYPE RANGE OF zetr_e_awtyp,
              lt_sddty_range         TYPE RANGE OF zetr_e_fkart,
              lt_mmdty_range         TYPE RANGE OF zetr_e_mmidt,
              lt_fidty_range         TYPE RANGE OF zetr_e_fidty,
              lt_ernam_range         TYPE RANGE OF abp_creation_user,
              lt_erdat_range         TYPE RANGE OF abp_creation_date,
              lt_output              TYPE TABLE OF zetr_ddl_i_unsaved_deliveries,
              lv_bukrs               TYPE bukrs,
              lo_delivery_operations TYPE REF TO zcl_etr_delivery_operations,
              lt_docui_range         TYPE RANGE OF sysuuid_c22,
              ls_document            TYPE zcl_etr_delivery_operations=>mty_outgoing_delivery.
        DATA(lt_paging) = io_request->get_paging( ).
        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'BUKRS'.
              lt_bukrs_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'BELNR'.
              lt_belnr_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'GJAHR'.
              lt_gjahr_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'AWTYP'.
              lt_awtyp_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'SDDTY'.
              lt_sddty_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'MMDTY'.
              lt_mmdty_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'FIDTY'.
              lt_fidty_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'ERNAM'.
              lt_ernam_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'ERDAT'.
              lt_erdat_range = CORRESPONDING #( ls_filter-range ).
          ENDCASE.
        ENDLOOP.

        IF 'BKPF' IN lt_awtyp_range.
          SELECT companycode AS bukrs,
                 accountingdocument AS belnr,
                 fiscalyear AS gjahr,
                 referencedocumenttype AS awtyp
            FROM i_journalentry
            WHERE companycode IN @lt_bukrs_range
              AND accountingdocument IN @lt_belnr_range
              AND fiscalyear IN @lt_gjahr_range
              AND referencedocumenttype IN ('BKPF','BKPFF')
              AND accountingdocumenttype IN @lt_fidty_range
              AND accountingdocumentcreationdate IN @lt_erdat_range
              AND accountingdoccreatedbyuser IN @lt_ernam_range
              AND isreversal = ''
              AND isreversed = ''
            INTO TABLE @DATA(lt_deliveries).
        ENDIF.

        IF 'LIKP' IN lt_awtyp_range.
          SELECT s~CompanyCode AS bukrs,
                 d~DeliveryDocument AS belnr,
                 CAST( left( DocumentDate, 4 ) AS NUMC ) AS gjahr,
                 'LIKP' AS awtyp
            FROM i_deliverydocument AS d
            INNER JOIN i_salesorganization AS s
              ON d~salesorganization = s~salesorganization
            WHERE companycode IN @lt_bukrs_range
              AND DeliveryDocument IN @lt_belnr_range
              AND CAST( left( billingdocumentdate, 4 ) AS NUMC ) IN @lt_gjahr_range
              AND deliverydocumenttype IN @lt_sddty_range
              AND creationdate IN @lt_erdat_range
              AND createdbyuser IN @lt_ernam_range
            APPENDING TABLE @lt_deliveries.
        ENDIF.

        IF 'MKPF' IN lt_awtyp_range.
          SELECT DISTINCT
                 i~companycode AS bukrs,
                 m~MaterialDocument AS belnr,
                 m~MaterialDocumentYear AS gjahr,
                 'MKPF' AS awtyp
            FROM I_MaterialDocumentHeader_2 AS m
            INNER JOIN i_materialdocumentitem_2 AS i
              ON  m~MaterialDocument = i~MaterialDocument
              AND m~MaterialDocumentYear = i~MaterialDocumentYear
            WHERE i~companycode IN @lt_bukrs_range
              AND m~MaterialDocument IN @lt_belnr_range
              AND m~MaterialDocumentYear IN @lt_gjahr_range
              AND m~accountingdocumenttype IN @lt_fidty_range
              AND m~creationdate IN @lt_erdat_range
              AND m~createdbyuser IN @lt_ernam_range
              AND i~GoodsMovementIsCancelled = ''
            APPENDING TABLE @lt_deliveries.
        ENDIF.
        CHECK lt_deliveries IS NOT INITIAL.
        SORT lt_deliveries BY bukrs awtyp belnr gjahr.

        LOOP AT lt_deliveries INTO DATA(ls_delivery).
          TRY.
              IF lv_bukrs <> ls_delivery-bukrs.
                CLEAR lo_delivery_operations.
                FREE lo_delivery_operations.
                lo_delivery_operations = zcl_etr_delivery_operations=>factory( ls_delivery-bukrs ).
                lv_bukrs = ls_delivery-bukrs.
              ENDIF.
              CLEAR: ls_document.
              ls_document = lo_delivery_operations->outgoing_delivery_save( iv_awtyp = ls_delivery-awtyp
                                                                            iv_bukrs = ls_delivery-bukrs
                                                                            iv_belnr = ls_delivery-belnr
                                                                            iv_gjahr = ls_delivery-gjahr ).
              CHECK ls_document IS NOT INITIAL.
              APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_document-docui ) TO lt_docui_range.
            CATCH zcx_etr_regulative_exception.
          ENDTRY.
        ENDLOOP.
        IF lt_docui_range IS NOT INITIAL.
          SELECT documentuuid AS docui ,
                 companycode AS bukrs ,
                 documentnumber AS belnr ,
                 fiscalyear AS gjahr ,
                 documenttype AS awtyp ,
                 documenttypetext AS awtyp_text,
                 partnernumber AS partner,
                 partnername AS partner_name,
                 taxid,
                 documentdate AS bldat,
                 referencedocumenttype AS docty,
                 referencedocumenttypetext AS docty_text,
                 profileid AS prfid,
                 deliverytype AS invty,
                 createdby AS ernam,
                 createdate AS erdat,
                 createtime AS erzet
            FROM zetr_ddl_i_outgoing_deliveries
            WHERE documentuuid IN @lt_docui_range
            INTO CORRESPONDING FIELDS OF TABLE @lt_output.
          IF io_request->is_total_numb_of_rec_requested(  ).
            io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_output ) ).
          ENDIF.
          io_response->set_data( it_data = lt_output ).
        ENDIF.

      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
  ENDMETHOD.