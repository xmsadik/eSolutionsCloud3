projection;
strict ( 2 );

define behavior for zetr_ddl_p_archive_parameters //alias <alias_name>
{
  use create;
  use update;
  use delete;

  use association _customParameters { create; }
  use association _invoiceSerials { create; }
  use association _xsltTemplates { create; }
  use association _invoiceRules { create; }
}

define behavior for zetr_ddl_p_archive_custom //alias <alias_name>
{
  use update;
  use delete;

  use association _eArchiveParameters;
}

define behavior for zetr_ddl_p_archive_rules //alias <alias_name>
{
  use update;
  use delete;

  use association _eArchiveParameters;
}

define behavior for zetr_ddl_p_archive_serials //alias <alias_name>
{
  use update;
  use delete;

  use association _eArchiveParameters;
}

define behavior for zetr_ddl_p_archive_xslttemp //alias <alias_name>
{
  use update;
  use delete;

  use association _eArchiveParameters;
}