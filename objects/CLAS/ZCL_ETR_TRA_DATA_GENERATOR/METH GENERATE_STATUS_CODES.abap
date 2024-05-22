  METHOD generate_status_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_rasta,
          lt_texts TYPE TABLE OF zetr_t_rastx.

    lt_codes = VALUE #( ( radsc = '1000'   rsend = ' '  rvrse = ' ' succs = ' ' )
                        ( radsc = '1100'   rsend = ' '  rvrse = ' ' succs = ' ' )
                        ( radsc = '1110'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1111'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1120'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1130'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1131'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1132'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1133'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1140'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1141'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1142'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1143'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1150'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1160'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1161'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1162'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1163'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1170'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1171'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1172'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1175'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1176'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1177'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1180'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1181'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1182'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1183'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1190'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1195'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1200'   rsend = ' '  rvrse = ' ' succs = ' ' )
                        ( radsc = '1210'   rsend = ' '  rvrse = 'X' succs = ' ' )
                        ( radsc = '1215'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1220'   rsend = ' '  rvrse = 'X' succs = ' ' )
                        ( radsc = '1230'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1300'   rsend = ' '  rvrse = ' ' succs = 'X' ) ).

    lt_texts = VALUE #( ( spras = 'T' radsc = '1000' bezei = 'Zarf kuyruğa eklendi' )
                        ( spras = 'T' radsc = '1100' bezei = 'Zarf işleniyor' )
                        ( spras = 'T' radsc = '1110' bezei = 'Zip dosyası değil' )
                        ( spras = 'T' radsc = '1111' bezei = 'Zarf ID uzunluğu geçersiz' )
                        ( spras = 'T' radsc = '1120' bezei = 'Zarf arşivden kopyalanamadı' )
                        ( spras = 'T' radsc = '1130' bezei = 'Zip açılamadı' )
                        ( spras = 'T' radsc = '1131' bezei = 'Zip bir dosya içermeli' )
                        ( spras = 'T' radsc = '1132' bezei = 'XML dosyası değil' )
                        ( spras = 'T' radsc = '1133' bezei = 'Zarf ID ve XML dosyasının adı aynı olmalı' )
                        ( spras = 'T' radsc = '1140' bezei = 'Döküman ayrıştırılamadı' )
                        ( spras = 'T' radsc = '1141' bezei = 'Zarf ID yok' )
                        ( spras = 'T' radsc = '1142' bezei = 'Zarf ID ve Zip dosyası adı aynı olmalı' )
                        ( spras = 'T' radsc = '1143' bezei = 'Geçersiz versiyon' )
                        ( spras = 'T' radsc = '1150' bezei = 'Schematron kontrol sonucu hatalı' )
                        ( spras = 'T' radsc = '1160' bezei = 'XML şema kontrolünden geçemedi' )
                        ( spras = 'T' radsc = '1161' bezei = 'İmza sahibi TCKN VKN alınamadı' )
                        ( spras = 'T' radsc = '1162' bezei = 'İmza kaydedilemedi' )
                        ( spras = 'T' radsc = '1163' bezei = 'Gönderilen zarf sistemde daha önce kayıtlı olan bir faturayı içermektedir' )
                        ( spras = 'T' radsc = '1170' bezei = 'Yetki kontrol edilemedi' )
                        ( spras = 'T' radsc = '1171' bezei = 'Gönderici birim yetkisi yok' )
                        ( spras = 'T' radsc = '1172' bezei = 'Posta kutusu yetkisi yok' )
                        ( spras = 'T' radsc = '1175' bezei = 'İmza yetkisi kontrol edilemedi' )
                        ( spras = 'T' radsc = '1176' bezei = 'İmza sahibi yetkisiz' )
                        ( spras = 'T' radsc = '1177' bezei = 'Geçersiz imza' )
                        ( spras = 'T' radsc = '1180' bezei = 'Adres kontrol edilemedi' )
                        ( spras = 'T' radsc = '1181' bezei = 'Adres bulunamadı' )
                        ( spras = 'T' radsc = '1182' bezei = 'Kullanıcı eklenemedi' )
                        ( spras = 'T' radsc = '1183' bezei = 'Kullanıcı silinemedi' )
                        ( spras = 'T' radsc = '1190' bezei = 'Sistem yanıtı hazırlanamadı' )
                        ( spras = 'T' radsc = '1195' bezei = 'Sistem hatası' )
                        ( spras = 'T' radsc = '1200' bezei = 'Zarf başarıyla işlendi' )
                        ( spras = 'T' radsc = '1210' bezei = 'Döküman bulunan adrese gönderilemedi' )
                        ( spras = 'T' radsc = '1215' bezei = 'Doküman gönderimi başarısız. Tekrar gönderme sonlandı' )
                        ( spras = 'T' radsc = '1220' bezei = 'Hedeften sistem yanıtı gelmedi' )
                        ( spras = 'T' radsc = '1230' bezei = 'Hedeften sistem yanıtı başarısız geldi' )
                        ( spras = 'T' radsc = '1300' bezei = 'Başarıyla tamamlandı' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    DELETE FROM zetr_t_rasta.
    DELETE FROM zetr_t_rastx.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_rasta FROM TABLE @lt_codes.
    INSERT zetr_t_rastx FROM TABLE @lt_texts.
    COMMIT WORK AND WAIT.
  ENDMETHOD.