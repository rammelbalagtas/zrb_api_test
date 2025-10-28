@EndUserText.label: 'OpenDelivery Soldto'
define abstract entity ZA_OPENDEL_IN_MATERIAL
{
  key sign         : abap.char( 1 );
  key range_option : abap.char( 2 );
  key low          : abap.char( 40 );
  key high         : abap.char( 40 );
  key dummy        : abap.char(1);
      _root        : association to parent za_opendel_input on $projection.dummy = _root.dummy;
}
