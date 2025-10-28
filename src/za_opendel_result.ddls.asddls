@EndUserText.label: 'Open delivery input'
define abstract entity ZA_OPENDEL_RESULT
{
      salesoff      : abap.char(4);
      soldto        : abap.char(10);
      shipto        : abap.char(10);
      delivery      : abap.char(10);
      delivery_item : abap.numc(6);
      material      : abap.char(40);
      sloc          : abap.char(4);
      sales_order   : abap.char(10);
      dlv_qty       : abap.dec(13,0);
      dlv_type      : abap.char(4);
      dlv_value     : abap.dec(13,2);
      plant         : abap.char(4);
      salesorg      : abap.char(4);
      distrchan     : abap.char(2);
      division      : abap.char(2);
}
