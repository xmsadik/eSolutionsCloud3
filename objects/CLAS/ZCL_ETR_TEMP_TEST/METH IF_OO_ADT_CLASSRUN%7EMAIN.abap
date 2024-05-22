  METHOD if_oo_adt_classrun~main.
    TRY.
        DELETE FROM ('E071') WHERE trkorr = 'XI1K900115' AND object = 'SPRX'.
      CATCH cx_root INTO DATA(lx_root).
        out->write( lx_root->get_text( ) ).
    ENDTRY.
    DATA(lv_subrc) = 0.
*  delete from zetr_t_arcd WHERE docui = 'brKKtcSo7jwlgOnbDwBV80' and docty = ''.
*  update zetr_t_icdlv set ruuid = '' where docui = 'brKKtcSo7jwlgOnbDwBV80'.
*    TRY.
*        DATA(lo_service) = zcl_etr_edelivery_ws=>factory( iv_company = '1000' ).
*        lo_service->get_incoming_deliveries(
*          EXPORTING
*            iv_date_from = '20240101'
*            iv_date_to   = '20240111'
*          IMPORTING
*            et_items     = DATA(lt_items)
*            et_list      = DATA(lt_list)
*        ).
**        CATCH zcx_etr_regulative_exception.
*
*        out->write( 'Başarılı' ).
*      CATCH cx_root INTO DATA(lx_root).
*        out->write( lx_root->get_text( ) ).
*    ENDTRY.

  ENDMETHOD.