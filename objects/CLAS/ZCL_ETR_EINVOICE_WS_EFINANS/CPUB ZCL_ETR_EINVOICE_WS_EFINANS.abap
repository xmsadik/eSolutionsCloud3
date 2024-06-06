CLASS zcl_etr_einvoice_ws_efinans DEFINITION
  PUBLIC
  INHERITING FROM zcl_etr_einvoice_ws
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF mty_document_status,
        aciklama                  TYPE string,
        alimtarihi                TYPE string,
        belgeno                   TYPE string,
        ettn                      TYPE string,
        yanitdetayi               TYPE string,
        yanitdurumu               TYPE string,
        yanitgonderimcevabidetayi TYPE string,
        yanitgonderimcevabikodu   TYPE string,
        yanitgonderimdurumu       TYPE string,
        yanitgonderimtarihi       TYPE string,
        sirano                    TYPE string,
        yereleaktarimdurumu       TYPE string,
        kepdurum                  TYPE string,
        gibiptaldurum             TYPE string,
      END OF mty_document_status .
    TYPES:
      BEGIN OF mty_incoming_document,
        belgeno         TYPE string,
        belgesirano     TYPE string,
        belgetarihi     TYPE string,
        ettn            TYPE string,
        zarfid          TYPE string,
        gonderenetiket  TYPE string,
        gonderenvkntckn TYPE string,
        belgexmlzipped  TYPE string,
*        odenecektutar           TYPE string,
*        odenecektutardovizcinsi TYPE string,
      END OF mty_incoming_document .
    TYPES:
      mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_user_alias,
        etiket                  TYPE string,
        etiketolusturulmazamani TYPE string,
      END OF mty_user_alias .
    TYPES:
      mty_user_alias_t TYPE STANDARD TABLE OF mty_user_alias WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_users,
        tip         TYPE string,
        kayitzamani TYPE string,
        unvan       TYPE string,
        vkntckn     TYPE string,
        hesaptipi   TYPE string,
        aktifetiket TYPE mty_user_alias_t,
      END OF mty_users .
    TYPES:
      mty_users_t TYPE STANDARD TABLE OF mty_users WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_user_list,
        efaturakayitlikullanici TYPE mty_users_t,
      END OF mty_user_list .
    TYPES:
      BEGIN OF mty_fat1_ekbilgi,
        anahtar TYPE string,
        deger   TYPE string,
      END OF mty_fat1_ekbilgi .
    TYPES:
      mty_fat1_ekbilgi_t TYPE STANDARD TABLE OF mty_fat1_ekbilgi WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_ekler,
        dosya_adi    TYPE string,
        mime_type    TYPE string,
        icerik       TYPE string,
        belge_turu   TYPE string,
        belge_tarihi TYPE string,
      END OF mty_fat1_ekler .
    TYPES:
      mty_fat1_ekler_t TYPE STANDARD TABLE OF mty_fat1_ekler WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_iadeyekonu,
        fatura_no     TYPE string,
        fatura_tarihi TYPE string,
      END OF mty_fat1_iadeyekonu .
    TYPES:
      mty_fat1_iadeyekonu_t TYPE STANDARD TABLE OF mty_fat1_iadeyekonu WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_vergi,
        ad              TYPE string,
        kod             TYPE string,
        matrah          TYPE string,
        oran            TYPE string,
        vergi_tutari    TYPE string,
        muafiyet_sebebi TYPE string,
      END OF mty_fat1_vergi .
    TYPES:
      mty_fat1_vergi_t TYPE STANDARD TABLE OF mty_fat1_vergi WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_vergiler,
        toplam_vergi_tutari TYPE string,
        vergi               TYPE mty_fat1_vergi_t,
      END OF mty_fat1_vergiler .
    TYPES:
      mty_fat1_vergiler_t TYPE STANDARD TABLE OF mty_fat1_vergiler WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_alicisatici,
        musteri_no    TYPE string,
        vergi_no      TYPE string,
        vergi_dairesi TYPE string,
        unvan         TYPE string,
        ulke          TYPE string,
        sehir         TYPE string,
        ilce          TYPE string,
        cadde_sokak   TYPE string,
        kasaba_koy    TYPE string,
        bina_adi      TYPE string,
        bina_no       TYPE string,
        kapi_no       TYPE string,
        posta_kodu    TYPE string,
        tel           TYPE string,
        fax           TYPE string,
        web_sitesi    TYPE string,
        eposta        TYPE string,
        sube_kodu     TYPE string,
        sube_adi      TYPE string,
        tapdk_no      TYPE string,
        adi           TYPE string,
        soyadi        TYPE string,
        etiket        TYPE string,
      END OF mty_fat1_alicisatici .
    TYPES:
      BEGIN OF mty_fat1_siparis,
        siparis_no     TYPE string,
        siparis_tarihi TYPE string,
      END OF mty_fat1_siparis .
    TYPES:
      BEGIN OF mty_fat1_irsaliye,
        irsaliye_no     TYPE string,
        irsaliye_tarihi TYPE string,
      END OF mty_fat1_irsaliye .
    TYPES:
      mty_fat1_irsaliye_t TYPE STANDARD TABLE OF mty_fat1_irsaliye WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_malkabul,
        mal_kabul_no     TYPE string,
        mal_kabul_tarihi TYPE string,
      END OF mty_fat1_malkabul .
    TYPES:
      mty_fat1_malkabul_t TYPE STANDARD TABLE OF mty_fat1_malkabul WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_satir,
        sira_no                TYPE string,
        alici_urun_kodu        TYPE string,
        satici_urun_kodu       TYPE string,
        uretici_urun_kodu      TYPE string,
        marka_adi              TYPE string,
        model_adi              TYPE string,
        urun_adi               TYPE string,
        tanim                  TYPE string,
        birim_kodu             TYPE string,
        birim_fiyat            TYPE string,
        miktar                 TYPE string,
        mal_hizmet_miktari     TYPE string,
        iskonto_artirim_nedeni TYPE string,
        iskonto_orani          TYPE string,
        iskonto_tutari         TYPE string,
        vergiler               TYPE mty_fat1_vergiler,
      END OF mty_fat1_satir .
    TYPES:
      mty_fat1_satir_t TYPE STANDARD TABLE OF mty_fat1_satir WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_belge,
        fatura_id                      TYPE string,
        fatura_no                      TYPE string,
        fatura_tarihi                  TYPE string,
        fatura_zamani                  TYPE string,
        fatura_tipi                    TYPE string,
        fatura_turu                    TYPE string,
        siparis_bilgisi                TYPE mty_fat1_siparis,
        irsaliye_bilgisi               TYPE mty_fat1_irsaliye_t,
        mal_kabul_bilgisi              TYPE mty_fat1_malkabul_t,
        son_odeme_tarihi               TYPE string,
        para_birimi                    TYPE string,
        alici                          TYPE mty_fat1_alicisatici,
        satici                         TYPE mty_fat1_alicisatici,
        fatura_satir                   TYPE mty_fat1_satir_t,
        toplam_mal_hizmet_miktari      TYPE string,
        toplam_iskonto_tutari          TYPE string,
        toplam_artirim_tutari          TYPE string,
        vergi_haric_toplam             TYPE string,
        vergi_dahil_tutar              TYPE string,
        yuvarlama_tutari               TYPE string,
        odenecek_tutar                 TYPE string,
        vergiler                       TYPE mty_fat1_vergiler_t,
        fatura_not                     TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
        iadeye_konu_olan_fatura_bilgil TYPE mty_fat1_iadeyekonu_t,
        ekler                          TYPE mty_fat1_ekler_t,
        ek_bilgiler                    TYPE mty_fat1_ekbilgi_t,
      END OF mty_fat1_belge .

    CONSTANTS mc_erpcode_parameter TYPE zetr_e_cuspa VALUE 'ERPCODE' ##NO_TEXT.

    METHODS: download_registered_taxpayers REDEFINITION.
    METHODS: outgoing_invoice_download REDEFINITION.
    METHODS: get_incoming_invoices REDEFINITION.
    METHODS: incoming_invoice_download REDEFINITION.
    METHODS: incoming_invoice_get_status REDEFINITION.
    METHODS: incoming_invoice_response REDEFINITION.
    METHODS: outgoing_invoice_send REDEFINITION,
      outgoing_invoice_get_status REDEFINITION,
      outgoing_invoice_cancel REDEFINITION.
