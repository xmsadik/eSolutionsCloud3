  PROTECTED SECTION.
    METHODS:
      init_global_data
        IMPORTING
          iv_bukrs TYPE bukrs,
      get_company,
      get_business_areas,
      get_docst_and_ledgrp,
      get_accounts,
      set_date,
      set_blart,
      get_f51_params,
      get_ledger_datas,
      last_day_of_months
        IMPORTING
          day_in                   TYPE datum
        RETURNING
          VALUE(last_day_of_month) TYPE datum.
