  METHOD generate_unit_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_units,
          lt_texts TYPE TABLE OF zetr_t_unitx,
          lt_match TYPE TABLE OF zetr_t_untmc.

    lt_codes = VALUE #( ( unitc = '3I' )
                        ( unitc = 'B32' )
                        ( unitc = 'BX' )
                        ( unitc = 'C62' )
                        ( unitc = 'CCT' )
                        ( unitc = 'CEN' )
                        ( unitc = 'CTM' )
                        ( unitc = 'D30' )
                        ( unitc = 'D32' )
                        ( unitc = 'D40' )
                        ( unitc = 'DMK' )
                        ( unitc = 'GFI' )
                        ( unitc = 'GRM' )
                        ( unitc = 'GT' )
                        ( unitc = 'GWH' )
                        ( unitc = 'KFO' )
                        ( unitc = 'KGM' )
                        ( unitc = 'KHY' )
                        ( unitc = 'KMA' )
                        ( unitc = 'KNI' )
                        ( unitc = 'KPH' )
                        ( unitc = 'KPO' )
                        ( unitc = 'KSD' )
                        ( unitc = 'KSH' )
                        ( unitc = 'KUR' )
                        ( unitc = 'KWH' )
                        ( unitc = 'KWT' )
                        ( unitc = 'LPA' )
                        ( unitc = 'LTR' )
                        ( unitc = 'MND' )
                        ( unitc = 'MTK' )
                        ( unitc = 'MTQ' )
                        ( unitc = 'MTR' )
                        ( unitc = 'MWH' )
                        ( unitc = 'NCL' )
                        ( unitc = 'PR' )
                        ( unitc = 'R9' )
                        ( unitc = 'SET' )
                        ( unitc = 'SM3' )
                        ( unitc = 'T3' ) ).

    lt_texts = VALUE #( ( spras = 'T' unitc = '3I ' bezei = 'KİLOGRAM-ADET' )
                        ( spras = 'T' unitc = 'B32' bezei = 'KG-METRE KARE' )
                        ( spras = 'T' unitc = 'BX ' bezei = 'KUTU' )
                        ( spras = 'T' unitc = 'C62' bezei = 'ADET(UNIT)' )
                        ( spras = 'T' unitc = 'CCT' bezei = 'TON BAŞINA TAŞIMA KAPASİTESİ' )
                        ( spras = 'T' unitc = 'CEN' bezei = 'YÜZ ADET' )
                        ( spras = 'T' unitc = 'CTM' bezei = 'KARAT' )
                        ( spras = 'T' unitc = 'D30' bezei = 'BRÜT KALORİ DEĞERİ' )
                        ( spras = 'T' unitc = 'D32' bezei = 'TERAWATT SAAT' )
                        ( spras = 'T' unitc = 'D40' bezei = 'BİN LİTRE' )
                        ( spras = 'T' unitc = 'DMK' bezei = 'DESİMETRE KARE' )
                        ( spras = 'T' unitc = 'GFI' bezei = 'FISSILE İZOTOP GRAMI' )
                        ( spras = 'T' unitc = 'GRM' bezei = 'GRAM' )
                        ( spras = 'T' unitc = 'GT ' bezei = 'GROSS TON' )
                        ( spras = 'T' unitc = 'GWH' bezei = 'GİGAWATT SAAT' )
                        ( spras = 'T' unitc = 'KFO' bezei = 'DİFOSFOR PENTAOKSİT KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KGM' bezei = 'KİLOGRAM' )
                        ( spras = 'T' unitc = 'KHY' bezei = 'HİDROJEN PEROKSİT KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KMA' bezei = 'METİL AMİNLERİN KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KNI' bezei = 'AZOTUN KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KPH' bezei = 'KİLOGRAM POTASYUM HİDROKSİT' )
                        ( spras = 'T' unitc = 'KPO' bezei = 'KİLOGRAM POTASYUM OKSİT' )
                        ( spras = 'T' unitc = 'KSD' bezei = '%90 KURU ÜRÜN KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KSH' bezei = 'SODYUM HİDROKSİT KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KUR' bezei = 'URANYUM KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KWH' bezei = 'KİLOWATT SAAT' )
                        ( spras = 'T' unitc = 'KWT' bezei = 'KİLOWATT' )
                        ( spras = 'T' unitc = 'LPA' bezei = 'SAF ALKOL LİTRESİ' )
                        ( spras = 'T' unitc = 'LTR' bezei = 'LİTRE' )
                        ( spras = 'T' unitc = 'MND' bezei = 'KURUTULMUŞ NET AĞIRLIKLI KİLOGRAMI' )
                        ( spras = 'T' unitc = 'MTK' bezei = 'METRE KARE' )
                        ( spras = 'T' unitc = 'MTQ' bezei = 'METRE KÜP' )
                        ( spras = 'T' unitc = 'MTR' bezei = 'METRE' )
                        ( spras = 'T' unitc = 'MWH' bezei = 'MEGAWATT SAAT (1000 kW.h)' )
                        ( spras = 'T' unitc = 'NCL' bezei = 'HÜCRE ADEDİ' )
                        ( spras = 'T' unitc = 'PR ' bezei = 'ÇİFT' )
                        ( spras = 'T' unitc = 'R9 ' bezei = 'BİN METRE KÜP' )
                        ( spras = 'T' unitc = 'SET' bezei = 'SET' )
                        ( spras = 'T' unitc = 'SM3' bezei = 'STANDART METREKÜP' )
                        ( spras = 'T' unitc = 'T3 ' bezei = 'BİN ADET' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    lt_match = VALUE #( ( meins = 'ST' unitc = 'C62' )
                        ( meins = 'G' unitc = 'GRM' )
                        ( meins = 'KG' unitc = 'KGM' )
                        ( meins = 'L' unitc = 'LTR' ) ).

    DELETE FROM zetr_t_units.
    DELETE FROM zetr_t_unitx.
    DELETE FROM zetr_t_untmc.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_units FROM TABLE @lt_codes.
    INSERT zetr_t_unitx FROM TABLE @lt_texts.
    INSERT zetr_t_untmc FROM TABLE @lt_match.
    COMMIT WORK AND WAIT.
  ENDMETHOD.