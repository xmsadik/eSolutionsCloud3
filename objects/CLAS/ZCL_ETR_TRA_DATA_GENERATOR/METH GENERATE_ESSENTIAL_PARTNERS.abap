  METHOD generate_essential_partners.
    DATA: lt_partners TYPE TABLE OF zetr_t_othp.

    lt_partners = VALUE #( ( taxid = '1460415308'
                             prtty = 'C'
                             title = 'Gümrük ve Ticaret Bakanlığı'
                             taxof = 'Ulus'
                             distr = 'Üniversiteler Mahallesi'
                             street = 'Dumlupınar Bulvarı'
                             bldno = '151'
                             subdv = 'Çankaya'
                             cityn = 'Ankara'
                             country = 'Türkiye'
                             email = 'ticaretbakanligi@hs01.kep.tr' ) ).

    DELETE FROM zetr_t_othp.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_othp FROM TABLE @lt_partners.
    COMMIT WORK AND WAIT.
  ENDMETHOD.