CLASS zcl_etr_outgoing_delivery DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES BEGIN OF mty_text_line.
    TYPES tdformat TYPE c LENGTH 2.
    TYPES tdline   TYPE c LENGTH 132.
    TYPES END OF mty_text_line.

    TYPES BEGIN OF mty_texts.
    TYPES tdobject TYPE c LENGTH 10.
    TYPES tdname   TYPE c LENGTH 70.
    TYPES tdid     TYPE c LENGTH 4.
    TYPES tdspras  TYPE spras.
    TYPES tline TYPE STANDARD TABLE OF mty_text_line WITH EMPTY KEY.
    TYPES END OF mty_texts .

    TYPES BEGIN OF mty_t001.
    TYPES bukrs TYPE bukrs.
    TYPES waers TYPE waers.
    TYPES land1 TYPE land1.
    TYPES ktopl TYPE ktopl.
    TYPES END OF mty_t001.

    TYPES BEGIN OF mty_t005.
    TYPES land1 TYPE land1.
    TYPES landx TYPE zetr_e_descr.
    TYPES END OF mty_t005.

    TYPES BEGIN OF mty_t005u.
    TYPES land1 TYPE land1.
    TYPES bland TYPE regio.
    TYPES bezei TYPE zetr_e_descr.
    TYPES END OF mty_t005u.

    TYPES BEGIN OF mty_bkpf.
    TYPES hwaer TYPE waers.
    TYPES waers TYPE waers.
    TYPES bldat TYPE datum.
    TYPES blart TYPE blart.
    TYPES kursf TYPE zetr_e_kursf.
    TYPES END OF mty_bkpf.

    TYPES BEGIN OF mty_bseg.
    TYPES buzei TYPE buzei.
    TYPES koart TYPE koart.
    TYPES shkzg TYPE shkzg.
    TYPES hkont TYPE hkont.
    TYPES txt50 TYPE zetr_e_descr.
    TYPES dmbtr TYPE wrbtr_cs.
    TYPES wrbtr TYPE wrbtr_cs.
    TYPES netdt TYPE datum.
    TYPES lokkt TYPE hkont.
    TYPES kunnr TYPE hkont.
    TYPES lifnr TYPE hkont.
    TYPES matnr TYPE matnr.
    TYPES sgtxt TYPE zetr_e_descr.
    TYPES mwskz TYPE mwskz.
    TYPES END OF mty_bseg.

    TYPES BEGIN OF mty_bsec.
    TYPES buzei TYPE buzei.
    TYPES stras TYPE zetr_e_descr.
    TYPES pstlz TYPE c LENGTH 10.
    TYPES land1 TYPE land1.
    TYPES regio TYPE regio.
    TYPES ort01 TYPE zetr_e_descr.
    TYPES name1 TYPE zetr_e_descr.
    TYPES name2 TYPE zetr_e_descr.
    TYPES stcd1 TYPE zetr_e_tax_office.
    TYPES stcd2 TYPE zetr_e_taxid.
    TYPES END OF mty_bsec.

    TYPES BEGIN OF mty_accdoc_data.
    TYPES t001 TYPE mty_t001.
    TYPES t005 TYPE SORTED TABLE OF mty_t005 WITH UNIQUE KEY land1.
    TYPES t005u TYPE SORTED TABLE OF mty_t005u WITH UNIQUE KEY land1 bland.
    TYPES bkpf TYPE mty_bkpf.
    TYPES bsec TYPE mty_bsec.
    TYPES bseg TYPE SORTED TABLE OF mty_bseg WITH UNIQUE KEY buzei
                                             WITH NON-UNIQUE SORTED KEY by_koart COMPONENTS koart shkzg
                                             WITH NON-UNIQUE SORTED KEY by_hkont COMPONENTS hkont shkzg.

    TYPES bseg_partner TYPE mty_bseg.
    TYPES address_number TYPE c LENGTH 10.
    TYPES taxid TYPE zetr_e_taxid.
    TYPES tax_office TYPE zetr_e_tax_office.
    TYPES accounts TYPE SORTED TABLE OF zetr_t_fiacc WITH UNIQUE KEY saknr
                                                     WITH NON-UNIQUE SORTED KEY by_accty COMPONENTS accty.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES END OF mty_accdoc_data .

    TYPES BEGIN OF mty_mkpf.
    TYPES mblnr TYPE belnr_d.
    TYPES mjahr TYPE gjahr.
    TYPES blart TYPE blart.
    TYPES END OF mty_mkpf.

    TYPES BEGIN OF mty_mseg.
    TYPES mblnr TYPE belnr_d.
    TYPES mjahr TYPE gjahr.
    TYPES zeile TYPE n LENGTH 4.
    TYPES menge TYPE menge_d.
    TYPES meins TYPE meins.
    TYPES xauto TYPE abap_boolean.
    TYPES ebeln TYPE belnr_d.
    TYPES ebelp TYPE n LENGTH 5.
    TYPES matnr TYPE matnr.
    TYPES maktx TYPE zetr_e_descr.
    TYPES kunnr TYPE zetr_e_partner.
    TYPES lifnr TYPE zetr_e_partner.
    TYPES umwrk TYPE zetr_e_umwrk.
    TYPES umlgo TYPE zetr_e_umlgo.
    TYPES END OF mty_mseg.

    TYPES BEGIN OF mty_ekpo.
    TYPES ebeln TYPE ebeln.
    TYPES ebelp TYPE ebelp.
    TYPES matnr TYPE matnr.
    TYPES maktx TYPE zetr_e_descr.
    TYPES txz01 TYPE zetr_e_descr.
    TYPES END OF mty_ekpo.

    TYPES BEGIN OF mty_ekko.
    TYPES ebeln TYPE ebeln.
    TYPES bedat TYPE datum.
    TYPES END OF mty_ekko.

    TYPES BEGIN OF mty_goodsmvmt_data.
    TYPES t001 TYPE mty_t001.
    TYPES t005 TYPE SORTED TABLE OF mty_t005 WITH UNIQUE KEY land1.
    TYPES t005u TYPE SORTED TABLE OF mty_t005u WITH UNIQUE KEY land1 bland.
    TYPES mkpf TYPE mty_mkpf.
    TYPES mseg TYPE SORTED TABLE OF mty_mseg WITH UNIQUE KEY zeile.
    TYPES ekpo TYPE SORTED TABLE OF mty_ekpo WITH UNIQUE KEY ebeln ebelp.
    TYPES ekko TYPE SORTED TABLE OF mty_ekko WITH UNIQUE KEY ebeln.
    TYPES address_number TYPE c LENGTH 10.
    TYPES taxid TYPE zetr_e_taxid.
    TYPES tax_office TYPE zetr_e_tax_office.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES END OF mty_goodsmvmt_data .

    TYPES BEGIN OF mty_likp.
    TYPES vbeln TYPE belnr_d.
    TYPES lfart TYPE c LENGTH 4.
    TYPES END OF mty_likp.

    TYPES BEGIN OF mty_lips.
    TYPES vbeln TYPE belnr_d.
    TYPES posnr TYPE n LENGTH 6.
    TYPES lfimg TYPE menge_d.
    TYPES vrkme TYPE meins.
    TYPES arktx TYPE zetr_e_descr.
    TYPES matnr TYPE matnr.
    TYPES vgbel TYPE belnr_d.
    TYPES vgpos TYPE n LENGTH 6.
    TYPES kdmat TYPE c LENGTH 35.
    TYPES END OF mty_lips.

    TYPES BEGIN OF mty_vbpa.
    TYPES vbeln TYPE belnr_d.
*    TYPES posnr TYPE n LENGTH 6.
    TYPES parvw TYPE c LENGTH 2.
    TYPES adrnr TYPE c LENGTH 10.
    TYPES kunnr TYPE zetr_e_partner.
    TYPES END OF mty_vbpa.

    TYPES BEGIN OF mty_vbak.
    TYPES vbeln TYPE belnr_d.
    TYPES audat TYPE datum.
    TYPES END OF mty_vbak.

    TYPES BEGIN OF mty_outdel_data.
    TYPES t001  TYPE mty_t001.
    TYPES t005 TYPE SORTED TABLE OF mty_t005 WITH UNIQUE KEY land1.
    TYPES t005u TYPE SORTED TABLE OF mty_t005u WITH UNIQUE KEY land1 bland.
    TYPES likp  TYPE mty_likp.
    TYPES lips  TYPE SORTED TABLE OF mty_lips WITH UNIQUE KEY posnr.
*    TYPES vbpa  TYPE SORTED TABLE OF mty_vbpa WITH UNIQUE KEY vbeln posnr parvw
    TYPES vbpa  TYPE SORTED TABLE OF mty_vbpa WITH UNIQUE KEY vbeln parvw
                                              WITH NON-UNIQUE SORTED KEY by_parvw COMPONENTS parvw.
    TYPES vbak TYPE SORTED TABLE OF mty_vbak WITH UNIQUE KEY vbeln.
    TYPES address_number TYPE c LENGTH 10.
    TYPES taxid TYPE zetr_e_taxid.
    TYPES tax_office TYPE zetr_e_tax_office.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES END OF mty_outdel_data .

    TYPES BEGIN OF mty_manual_data.
    TYPES t001 TYPE mty_t001.
    TYPES t005 TYPE SORTED TABLE OF mty_t005 WITH UNIQUE KEY land1.
    TYPES t005u TYPE SORTED TABLE OF mty_t005u WITH UNIQUE KEY land1 bland.
    TYPES head TYPE zetr_t_ogdlv.
    TYPES items TYPE SORTED TABLE OF zetr_t_ogdli WITH UNIQUE KEY linno.
    TYPES vbak TYPE SORTED TABLE OF mty_vbak WITH UNIQUE KEY vbeln.
    TYPES address_number TYPE c LENGTH 10.
    TYPES taxid TYPE zetr_e_taxid.
    TYPES tax_office TYPE zetr_e_tax_office.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES END OF mty_manual_data .

    TYPES BEGIN OF mty_item_collect.
    TYPES posnr TYPE n LENGTH 6.
    TYPES matnr TYPE matnr.
    TYPES kdmat TYPE c LENGTH 35.
    TYPES admat TYPE c LENGTH 35.
    TYPES arktx TYPE zetr_e_notes.
    TYPES descr TYPE zetr_e_notes.
    TYPES lfimg TYPE menge_d.
    TYPES vrkme TYPE meins.
    TYPES netwr TYPE wrbtr_cs.
    TYPES netpr TYPE c LENGTH 20.
    TYPES peinh TYPE c LENGTH 20.
    TYPES netwa TYPE waers.
    TYPES END OF mty_item_collect .
    TYPES mty_item_collect_t TYPE TABLE OF mty_item_collect .
    TYPES mty_delivery_items TYPE TABLE OF zetr_t_ogdli WITH EMPTY KEY.

    TYPES BEGIN OF mty_custom_parameters.
    TYPES cuspa TYPE zetr_e_cuspa.
    TYPES value TYPE zetr_e_value.
    TYPES END OF mty_custom_parameters.
    TYPES mty_custom_parameters_t TYPE STANDARD TABLE OF mty_custom_parameters WITH EMPTY KEY.

    TYPES mty_delivery_rules_out TYPE STANDARD TABLE OF zetr_s_delivery_rules_out WITH EMPTY KEY.

    CLASS-METHODS factory
      IMPORTING
        !iv_document_uuid TYPE sysuuid_c22
        !iv_preview       TYPE abap_boolean OPTIONAL
      RETURNING
        VALUE(ro_object)  TYPE REF TO zcl_etr_outgoing_delivery
      RAISING
        zcx_etr_regulative_exception .

    METHODS build_delivery_data
      EXPORTING
        !es_delivery_ubl      TYPE zif_etr_delivery_ubl21=>despatchadvicetype
        !ev_delivery_ubl      TYPE xstring
        !ev_delivery_hash     TYPE string
        !et_custom_parameters TYPE mty_custom_parameters_t
      RAISING
        zcx_etr_regulative_exception.

    METHODS ubl_fill_partner_data
      IMPORTING
        !iv_address_number TYPE belnr_d
        !iv_profile_id     TYPE zetr_e_dlprf OPTIONAL
        !iv_tax_office     TYPE zetr_e_tax_office OPTIONAL
        !iv_tax_id         TYPE zetr_e_taxid OPTIONAL
      RETURNING
        VALUE(rs_data)     TYPE zif_etr_common_ubl21=>partytype
      RAISING
        zcx_etr_regulative_exception .

    METHODS generate_delivery_id
      IMPORTING
        iv_save_db               TYPE abap_boolean DEFAULT abap_true
      RETURNING
        VALUE(rv_invoice_number) TYPE zetr_e_docno
      RAISING
        zcx_etr_regulative_exception
        cx_number_ranges.
