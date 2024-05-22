CLASS zcl_etr_edelivery_ws_efinans DEFINITION
  PUBLIC
  INHERITING FROM zcl_etr_edelivery_ws
  FINAL
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
        yanitettn                 TYPE string,
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
      END OF mty_incoming_document .
    TYPES:
      mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_user_alias,
        etiket                  TYPE String,
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

    METHODS: download_registered_taxpayers REDEFINITION.
    METHODS: get_incoming_deliveries REDEFINITION.
    METHODS: incoming_delivery_download REDEFINITION.
    METHODS: incoming_delivery_get_status REDEFINITION.
    METHODS: incoming_delivery_respdown REDEFINITION.
    METHODS: incoming_delivery_response REDEFINITION.
    METHODS: outgoing_delivery_send REDEFINITION,
      outgoing_delivery_get_status REDEFINITION,
      outgoing_delivery_download REDEFINITION,
      outgoing_delivery_respdown REDEFINITION.