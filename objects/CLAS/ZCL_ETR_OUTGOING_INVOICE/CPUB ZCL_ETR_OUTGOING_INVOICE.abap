CLASS zcl_etr_outgoing_invoice DEFINITION
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
    TYPES kalsm TYPE c LENGTH 6.
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
    TYPES bukrs TYPE bukrs.
    TYPES belnr TYPE belnr_d.
    TYPES gjahr TYPE gjahr.
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

    TYPES BEGIN OF mty_invrec_headerdata.
    TYPES document_number TYPE belnr_d.
    TYPES fiscal_year TYPE gjahr.
    TYPES doc_date TYPE datum.
    TYPES doc_type TYPE blart.
    TYPES currency TYPE waers.
    TYPES exch_rate TYPE zetr_e_kursf.
    TYPES gross_amnt TYPE wrbtr_cs.
    TYPES diff_inv TYPE lifnr.
    TYPES END OF mty_invrec_headerdata.

    TYPES BEGIN OF mty_invrec_itemdata.
    TYPES invoice_doc_item TYPE n LENGTH 6.
    TYPES po_number TYPE belnr_d.
    TYPES po_item TYPE n LENGTH 5.
    TYPES item_text TYPE zetr_e_descr.
    TYPES quantity TYPE menge_d.
    TYPES po_unit TYPE meins.
    TYPES item_amount TYPE wrbtr_cs.
    TYPES tax_code TYPE mwskz.
    TYPES END OF mty_invrec_itemdata.

    TYPES BEGIN OF mty_invrec_glaccountdata.
    TYPES invoice_doc_item TYPE n LENGTH 6.
    TYPES item_text TYPE zetr_e_descr.
    TYPES item_amount TYPE wrbtr_cs.
    TYPES tax_code TYPE mwskz.
    TYPES END OF mty_invrec_glaccountdata.

    TYPES BEGIN OF mty_invrec_materialdata.
    TYPES invoice_doc_item TYPE n LENGTH 6.
    TYPES material TYPE matnr.
    TYPES material_text TYPE zetr_e_descr.
    TYPES quantity TYPE menge_d.
    TYPES base_uom TYPE meins.
    TYPES item_amount TYPE wrbtr_cs.
    TYPES tax_code TYPE mwskz.
    TYPES END OF mty_invrec_materialdata.

    TYPES BEGIN OF mty_ekpo.
    TYPES ebeln TYPE ebeln.
    TYPES ebelp TYPE ebelp.
    TYPES matnr TYPE matnr.
    TYPES maktx TYPE zetr_e_descr.
    TYPES txz01 TYPE zetr_e_descr.
    TYPES END OF mty_ekpo.

    TYPES BEGIN OF mty_ekbe.
    TYPES ebeln TYPE ebeln.
    TYPES ebelp TYPE ebelp.
    TYPES zekkn TYPE dzekkn.
    TYPES vgabe TYPE c LENGTH 1.
    TYPES gjahr TYPE mjahr.
    TYPES belnr TYPE mblnr.
    TYPES buzei TYPE mblpo.
    TYPES budat TYPE datum.
    TYPES menge TYPE menge_d.
    TYPES xblnr TYPE c LENGTH 16.
    TYPES END OF mty_ekbe.

    TYPES BEGIN OF mty_mseg.
    TYPES mblnr TYPE mblnr.
    TYPES mjahr TYPE mjahr.
    TYPES zeile TYPE buzei.
    TYPES END OF mty_mseg.

    TYPES BEGIN OF mty_invrec_data.
    TYPES t001 TYPE mty_t001.
    TYPES t005 TYPE SORTED TABLE OF mty_t005 WITH UNIQUE KEY land1.
    TYPES headerdata TYPE mty_invrec_headerdata.
    TYPES itemdata TYPE TABLE OF mty_invrec_itemdata WITH DEFAULT KEY.
    TYPES glaccountdata TYPE TABLE OF mty_invrec_glaccountdata WITH DEFAULT KEY.
    TYPES materialdata TYPE TABLE OF mty_invrec_materialdata WITH DEFAULT KEY.
    TYPES address_number TYPE c LENGTH 10.
    TYPES taxid TYPE zetr_e_taxid.
    TYPES tax_office TYPE zetr_e_tax_office.
    TYPES ekpo TYPE SORTED TABLE OF mty_ekpo WITH UNIQUE KEY ebeln ebelp.
    TYPES ekbe TYPE SORTED TABLE OF mty_ekbe WITH UNIQUE KEY ebeln ebelp zekkn vgabe gjahr belnr buzei.
*    TYPES mseg TYPE SORTED TABLE OF mty_mseg WITH UNIQUE KEY mblnr mjahr zeile.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES END OF mty_invrec_data .

    TYPES BEGIN OF mty_vbrk.
    TYPES vbeln TYPE belnr_d.
    TYPES waerk TYPE waers.
    TYPES inco1 TYPE c LENGTH 3.
    TYPES exnum TYPE c LENGTH 10.
    TYPES erdat TYPE datum.
    TYPES fkdat TYPE datum.
    TYPES netdt TYPE datum.
    TYPES fkart TYPE zetr_e_fkart.
    TYPES zterm TYPE dzterm.
    TYPES kurrf TYPE zetr_e_kursf.
    TYPES kurrf_dat TYPE datum.
    TYPES netwr TYPE wrbtr_cs.
    TYPES kunre TYPE zetr_e_partner.
    TYPES adrre TYPE c LENGTH 10.
    TYPES knumv TYPE c LENGTH 10.
    TYPES END OF mty_vbrk.

    TYPES BEGIN OF mty_vbrp.
    TYPES posnr TYPE n LENGTH 6.
    TYPES fkimg TYPE menge_d.
    TYPES vrkme TYPE meins.
    TYPES matnr TYPE matnr.
    TYPES arktx TYPE zetr_e_descr.
    TYPES werks TYPE werks_d.
    TYPES herkl TYPE land1.
    TYPES herkx TYPE zetr_e_descr.
    TYPES hscod TYPE c LENGTH 20.
    TYPES vgbel TYPE belnr_d.
    TYPES vgpos TYPE n LENGTH 6.
    TYPES vgvsa TYPE c LENGTH 2.
    TYPES vgxbl TYPE c LENGTH 16.
    TYPES vglfx TYPE c LENGTH 35.
    TYPES vgdat TYPE datum.
    TYPES aubel TYPE belnr_d.
    TYPES aupos TYPE n LENGTH 6.
    TYPES audat TYPE datum.
    TYPES aumat TYPE c LENGTH 35.
    TYPES aubst TYPE c LENGTH 35.
    TYPES auvsa TYPE c LENGTH 2.
    TYPES kunwe TYPE zetr_e_partner.
    TYPES adrwe TYPE c LENGTH 10.
    TYPES netwr TYPE wrbtr_cs.
    TYPES kzwi1 TYPE wrbtr_cs.
    TYPES kzwi2 TYPE wrbtr_cs.
    TYPES kzwi3 TYPE wrbtr_cs.
    TYPES kzwi4 TYPE wrbtr_cs.
    TYPES kzwi5 TYPE wrbtr_cs.
    TYPES kzwi6 TYPE wrbtr_cs.
    TYPES END OF mty_vbrp.

    TYPES BEGIN OF mty_konv.
    TYPES kposn TYPE n LENGTH 6.
    TYPES stunr TYPE n LENGTH 3.
    TYPES zaehk TYPE n LENGTH 3.
    TYPES kschl TYPE c LENGTH 4.
    TYPES kinak TYPE c LENGTH 1.
    TYPES koaid TYPE c LENGTH 1.
    TYPES kbetr TYPE wrbtr_cs.
    TYPES kwert TYPE wrbtr_cs.
    TYPES konwa TYPE waers.
    TYPES kkurs TYPE zetr_e_kursf.
    TYPES kpein TYPE p LENGTH 5 DECIMALS 0.
    TYPES kmein TYPE meins.
    TYPES mwsk1 TYPE mwskz.
    TYPES END OF mty_konv.

    TYPES BEGIN OF mty_billing_data.
    TYPES t001  TYPE mty_t001.
    TYPES vbrk  TYPE mty_vbrk.
    TYPES vbrp  TYPE STANDARD TABLE OF mty_vbrp WITH EMPTY KEY."  WITH UNIQUE KEY posnr.
    TYPES konv  TYPE SORTED TABLE OF mty_konv WITH UNIQUE KEY kposn stunr zaehk
                                              WITH NON-UNIQUE SORTED KEY by_kschl COMPONENTS kposn kschl kinak
                                              WITH NON-UNIQUE SORTED KEY by_koaid COMPONENTS kposn koaid kinak.
    TYPES address_number TYPE c LENGTH 10.
    TYPES taxid TYPE zetr_e_taxid.
    TYPES tax_office TYPE zetr_e_tax_office.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES conditions TYPE SORTED TABLE OF zetr_t_inv_cond WITH UNIQUE KEY kschl
                                                          WITH NON-UNIQUE SORTED KEY by_cndty COMPONENTS cndty
                                                          WITH NON-UNIQUE SORTED KEY by_kschl COMPONENTS kschl cndty.
    TYPES END OF mty_billing_data .

    TYPES BEGIN OF mty_export_spec_data.
    TYPES kunwe TYPE zetr_e_partner.
    TYPES adrwe TYPE c LENGTH 10.
    TYPES inco1 TYPE c LENGTH 3.
    TYPES trnty TYPE zetr_e_trnsp.
    TYPES hscod TYPE c LENGTH 20.
    TYPES kwrfr TYPE wrbtr_cs.
    TYPES kwrin TYPE wrbtr_cs.
    TYPES kapad TYPE i.
    TYPES END OF mty_export_spec_data .

    TYPES BEGIN OF mty_item_collect.
    TYPES posnr TYPE n LENGTH 6.
    TYPES matnr TYPE matnr.
    TYPES kdmat TYPE c LENGTH 35.
    TYPES admat TYPE c LENGTH 35.
    TYPES arktx TYPE zetr_e_notes.
    TYPES descr TYPE zetr_e_notes.
    TYPES model TYPE zetr_e_notes.
    TYPES brand TYPE zetr_e_notes.
    TYPES fkimg TYPE menge_d.
    TYPES vrkme TYPE meins.
    TYPES netwr TYPE wrbtr_cs.
    TYPES netpr TYPE c LENGTH 20.
    TYPES peinh TYPE c LENGTH 20.
    TYPES herkl TYPE land1.
    TYPES herkx TYPE zetr_e_descr.
    TYPES netwa TYPE waers.
    TYPES disrt TYPE c LENGTH 20.
    TYPES distr TYPE wrbtr_cs.
    TYPES surrt TYPE c LENGTH 20.
    TYPES surtr TYPE wrbtr_cs.
    TYPES mwskz TYPE mwskz.
    TYPES mwsbp TYPE wrbtr_cs.
    TYPES othtx TYPE wrbtr_cs.
    TYPES othtt TYPE zetr_e_taxty.
    TYPES othtr TYPE c LENGTH 20.
    TYPES waers TYPE waers.
    TYPES cfld1 TYPE zetr_e_descr.
    TYPES cfld2 TYPE zetr_e_descr.
    TYPES cfld3 TYPE zetr_e_descr.
    TYPES cfld4 TYPE zetr_e_descr.
    TYPES cfld5 TYPE zetr_e_descr.
    INCLUDE TYPE mty_export_spec_data.
    TYPES END OF mty_item_collect .
    TYPES mty_item_collect_t TYPE TABLE OF mty_item_collect .

    TYPES BEGIN OF mty_item_allowance.
    TYPES posnr TYPE n LENGTH 6.
    TYPES disrt TYPE c LENGTH 20.
    TYPES distr TYPE wrbtr_cs.
    TYPES surrt TYPE c LENGTH 20.
    TYPES surtr TYPE wrbtr_cs.
    TYPES END OF mty_item_allowance .
    TYPES mty_item_allowance_t TYPE TABLE OF mty_item_allowance .

    TYPES BEGIN OF mty_custom_parameters.
    TYPES cuspa TYPE zetr_e_cuspa.
    TYPES value TYPE zetr_e_value.
    TYPES END OF mty_custom_parameters.
    TYPES mty_custom_parameters_t TYPE STANDARD TABLE OF mty_custom_parameters WITH EMPTY KEY.

    TYPES mty_hash_code TYPE string.
    TYPES mty_invoice_rules_out TYPE STANDARD TABLE OF zetr_s_invoice_rules_out WITH EMPTY KEY.
    TYPES mty_kalsm TYPE c LENGTH 6.

    CLASS-METHODS factory
      IMPORTING
        !iv_document_uuid TYPE sysuuid_c22
        !iv_preview       TYPE abap_boolean OPTIONAL
      RETURNING
        VALUE(ro_object)  TYPE REF TO zcl_etr_outgoing_invoice
      RAISING
        zcx_etr_regulative_exception .

    METHODS build_invoice_data
      EXPORTING
        !es_invoice_ubl       TYPE zif_etr_invoice_ubl21=>invoicetype
        !ev_invoice_ubl       TYPE xstring
        !ev_invoice_hash      TYPE mty_hash_code
        !et_custom_parameters TYPE mty_custom_parameters_t
      RAISING
        zcx_etr_regulative_exception .

    METHODS generate_invoice_id
      IMPORTING
        iv_save_db               TYPE abap_boolean DEFAULT abap_true
      RETURNING
        VALUE(rv_invoice_number) TYPE zetr_e_docno
      RAISING
        zcx_etr_regulative_exception
        cx_number_ranges.
