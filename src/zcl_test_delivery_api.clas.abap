CLASS zcl_test_delivery_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS c_api_key      TYPE string VALUE `AWDAvmzST6MTgpWKBfGz5lCoxW2Rtgc2`.
    CONSTANTS c_api_endpoint TYPE string VALUE `https://sandbox.api.sap.com`.

    CLASS-METHODS: read_delivery IMPORTING is_parameters TYPE zcl_open_delivery=>ty_parameters
                                 EXPORTING et_data       TYPE ANY TABLE.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_test_delivery_api IMPLEMENTATION.

  METHOD read_delivery.

    DATA:
      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request      TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response     TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    DATA:
      lt_range_delivery_type TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-delivery_document_type,
      lt_range_soldto        TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-sold_to_party,
      lt_range_shipto        TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-ship_to_party,
      lt_range_salesorg      TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-sales_organization,
      lt_range_billblock     TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-header_billing_block_reaso,
      lt_range_delivery      TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-delivery_document,
      lt_range_status        TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-overall_sdprocess_status.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( c_api_endpoint ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        ASSERT lo_http_client IS BOUND.

        lo_http_client->get_http_request( )->set_header_field( i_name  = 'APIKey'
                                                               i_value = c_api_key ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSVC_DELIVERY_API'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/s4hanacloud/sap/opu/odata/sap/API_OUTBOUND_DELIVERY_SRV;v=0002/' ).

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_OUTB_DELIVERY_HEADER' )->create_request_for_read( ).
        lo_request->set_select_properties( VALUE #( ( CONV #( 'DELIVERY_DOCUMENT' ) )
                                                    ( CONV #( 'DELIVERY_DOCUMENT_TYPE' ) )
                                                    ( CONV #( 'SOLD_TO_PARTY' ) )
                                                    ( CONV #( 'SHIP_TO_PARTY' ) )
                                                    ( CONV #( 'HEADER_BILLING_BLOCK_REASO' ) )
                                                    ( CONV #( 'SALES_ORGANIZATION' ) ) ) ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).

        APPEND INITIAL LINE TO lt_range_delivery_type ASSIGNING FIELD-SYMBOL(<fs_delivery_type>).
        <fs_delivery_type>-sign = 'I'.
        <fs_delivery_type>-option = 'EQ'.
        <fs_delivery_type>-low = 'LF'.

        DATA(lo_filter_node1) = lo_filter_factory->create_by_range( iv_property_path     = 'DELIVERY_DOCUMENT_TYPE'
                                                                    it_range             = lt_range_delivery_type ).

        IF is_parameters-input-range_soldto IS NOT INITIAL.
          LOOP AT is_parameters-input-range_soldto INTO DATA(ls_range_soldto).
            APPEND INITIAL LINE TO lt_range_soldto ASSIGNING FIELD-SYMBOL(<fs_range_soldto>).
            <fs_range_soldto>-sign = ls_range_soldto-sign.
            <fs_range_soldto>-option = ls_range_soldto-range_option.
            <fs_range_soldto>-low = ls_range_soldto-low.
            <fs_range_soldto>-high = ls_range_soldto-high.
          ENDLOOP.
          DATA(lo_filter_node2)  = lo_filter_factory->create_by_range( iv_property_path     = 'SOLD_TO_PARTY'
                                                                       it_range             = lt_range_soldto ).
        ENDIF.

        IF is_parameters-input-range_soldto IS NOT INITIAL.
          LOOP AT is_parameters-input-range_shipto INTO DATA(ls_range_shipto).
            APPEND INITIAL LINE TO lt_range_shipto ASSIGNING FIELD-SYMBOL(<fs_range_shipto>).
            <fs_range_shipto>-sign = ls_range_shipto-sign.
            <fs_range_shipto>-option = ls_range_shipto-range_option.
            <fs_range_shipto>-low = ls_range_shipto-low.
            <fs_range_shipto>-high = ls_range_shipto-high.
            DATA(lo_filter_node3)  = lo_filter_factory->create_by_range( iv_property_path     = 'SHIP_TO_PARTY'
                                                                         it_range             = lt_range_shipto ).
          ENDLOOP.
        ENDIF.

        APPEND INITIAL LINE TO lt_range_status ASSIGNING FIELD-SYMBOL(<fs_range_status>).
        <fs_range_status>-sign = 'E'.
        <fs_range_status>-option = 'EQ'.
        <fs_range_status>-low = 'C'.

        DATA(lo_filter_node4) = lo_filter_factory->create_by_range( iv_property_path     = 'OVERALL_SDPROCESS_STATUS'
                                                                    it_range             = lt_range_status ).
        lo_filter_node_root = lo_filter_node1->and( lo_filter_node4 ).
*        lo_filter_node_root = lo_filter_node1.
        IF lo_filter_node2 IS NOT INITIAL.
          lo_filter_node_root = lo_filter_node_root->and( lo_filter_node2 ).
        ENDIF.
        IF lo_filter_node3 IS NOT INITIAL.
          lo_filter_node_root = lo_filter_node_root->and( lo_filter_node3 ).
        ENDIF.
        lo_request->set_filter( lo_filter_node_root ).

        DATA: lo_expand_node_root TYPE REF TO /iwbep/if_cp_expand_node,
              lo_expand_node      TYPE REF TO /iwbep/if_cp_expand_node.

        lo_expand_node_root = lo_request->create_expand_node( ).
        lo_expand_node = lo_expand_node_root->add_expand( 'TO_DELIVERY_DOCUMENT_ITEM' ).
        lo_expand_node->set_select_properties( VALUE #( ( CONV #( 'MATERIAL' ) )
                                                        ( CONV #( 'STORAGE_LOCATION' ) )
                                                        ( CONV #( 'DISTRIBUTION_CHANNEL' ) )
                                                        ( CONV #( 'DIVISION' ) )
                                                        ( CONV #( 'PLANT' ) )
                                                        ( CONV #( 'REFERENCE_SDDOCUMENT' ) )
                                                        ( CONV #( 'REFERENCE_SDDOCUMENT_ITEM' ) )
                                                        ( CONV #( 'SALES_OFFICE' ) ) ) ).

        lo_request->set_top( is_parameters-top )->set_skip( is_parameters-skip ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = et_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.

    ENDTRY.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA:
      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request      TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response     TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    DATA:
      lt_range_delivery_type TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-delivery_document_type,
      lt_range_soldto        TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-sold_to_party,
      lt_range_shipto        TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-ship_to_party,
      lt_range_salesorg      TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-sales_organization,
      lt_range_billblock     TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-header_billing_block_reaso,
      lt_range_delivery      TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-delivery_document,
      lt_range_status        TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-overall_sdprocess_status.

    TRY.

        DATA(lv_string) = `https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/API_OUTBOUND_DELIVERY_SRV;v=0002/A_OutbDeliveryHeader?$expand=to_DeliveryDocumentItem&$top=1&$format=json&$select=DeliveryDate`.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( lv_string ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        ASSERT lo_http_client IS BOUND.

        lo_http_client->get_http_request( )->set_header_field( i_name  = 'APIKey'
                                                               i_value = c_api_key ).

*        lo_http_client->get_http_request( )->set_header_field( i_name  = '~request_uri'
*                                                               i_value = '/s4hanacloud/sap/opu/odata/sap/API_OUTBOUND_DELIVERY_SRV;v=0002/A_OutbDeliveryHeader?$expand=to_DeliveryDocumentItem&$top=10&$format=json' ).

        DATA(lr_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

        DATA(lv_text) = lr_response->get_text( ).
        DATA(lv_status) =  lr_response->get_status( ).


      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
