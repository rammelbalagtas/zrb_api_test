@EndUserText.label: 'Open delivery input'
define root abstract entity za_opendel_input
{
  key dummy              : abap.char(1);
      salesoff           : abap.char(4);
      plant              : abap.char(4);
      salesorg           : abap.char(4);
      distrchan          : abap.char(2);
      division           : abap.char(2);
      _range_soldto      : composition [0..*] of za_opendel_in_soldto;
      _range_shipto      : composition [0..*] of ZA_OPENDEL_IN_SHIPTO;
      _range_material    : composition [0..*] of ZA_OPENDEL_IN_MATERIAL;
      _range_delivery    : composition [0..*] of ZA_OPENDEL_IN_DELIVERY;
      _range_sales_order : composition [0..*] of ZA_OPENDEL_IN_SALES_ORDER;
      _range_bill_block  : composition [0..*] of ZA_OPENDEL_IN_BILL_BLOCK;
}
