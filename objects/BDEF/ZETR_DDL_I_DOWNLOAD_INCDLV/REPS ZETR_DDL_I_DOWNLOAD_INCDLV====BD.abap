unmanaged implementation in class zbp_etr_ddl_i_download_incdlv unique;
strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ZETR_DDL_I_DOWNLOAD_INCDLV //alias <alias_name>
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
  field ( readonly : update ) docui;
  //  create;
  //  update;
  //  delete;
}