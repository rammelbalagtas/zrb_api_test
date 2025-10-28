CLASS zcl_test_delivery_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS c_api_key      TYPE string VALUE `2baUSS3WkDjAgLy3914XzxLK32LKCFRO`.
    CONSTANTS c_api_endpoint TYPE string VALUE `https://sandbox.api.sap.com`.

    TYPES: BEGIN OF ty_parameters,
             top    TYPE i,
             skip   TYPE i,
             filter TYPE zcl_open_delivery=>ty_input,
           END OF ty_parameters.

    TYPES: BEGIN OF ty_range_soldto,
             sign         TYPE c LENGTH 1,
             range_option TYPE c LENGTH 2,
             low          TYPE c LENGTH 10,
             high         TYPE c LENGTH 10,
           END OF ty_range_soldto.

    TYPES: BEGIN OF ty_range_shipto,
             sign         TYPE c LENGTH 1,
             range_option TYPE c LENGTH 2,
             low          TYPE c LENGTH 10,
             high         TYPE c LENGTH 10,
           END OF ty_range_shipto.

    TYPES: BEGIN OF ty_range_material,
             sign         TYPE c LENGTH 1,
             range_option TYPE c LENGTH 2,
             low          TYPE c LENGTH 40,
             high         TYPE c LENGTH 40,
           END OF ty_range_material.

    TYPES: BEGIN OF ty_range_delivery,
             sign         TYPE c LENGTH 1,
             range_option TYPE c LENGTH 2,
             low          TYPE c LENGTH 10,
             high         TYPE c LENGTH 10,
           END OF ty_range_delivery.

    TYPES: BEGIN OF ty_range_sales_order,
             sign         TYPE c LENGTH 1,
             range_option TYPE c LENGTH 2,
             low          TYPE c LENGTH 10,
             high         TYPE c LENGTH 10,
           END OF ty_range_sales_order.

    TYPES: BEGIN OF ty_range_bill_block,
             sign         TYPE c LENGTH 1,
             range_option TYPE c LENGTH 2,
             low          TYPE c LENGTH 2,
             high         TYPE c LENGTH 2,
           END OF ty_range_bill_block.

    CLASS-METHODS: read_delivery IMPORTING is_parameters TYPE ty_parameters
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
      lt_range_delivery      TYPE RANGE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ-delivery_document.

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

        IF is_parameters-filter-range_soldto IS NOT INITIAL.
          LOOP AT is_parameters-filter-range_soldto INTO DATA(ls_range_soldto).
            APPEND INITIAL LINE TO lt_range_soldto ASSIGNING FIELD-SYMBOL(<fs_range_soldto>).
            <fs_range_soldto>-sign = ls_range_soldto-sign.
            <fs_range_soldto>-option = ls_range_soldto-range_option.
            <fs_range_soldto>-low = ls_range_soldto-low.
            <fs_range_soldto>-high = ls_range_soldto-high.
          ENDLOOP.
          DATA(lo_filter_node2)  = lo_filter_factory->create_by_range( iv_property_path     = 'SOLD_TO_PARTY'
                                                                       it_range             = lt_range_soldto ).
        ENDIF.

        IF is_parameters-filter-range_soldto IS NOT INITIAL.
          LOOP AT is_parameters-filter-range_shipto INTO DATA(ls_range_shipto).
            APPEND INITIAL LINE TO lt_range_shipto ASSIGNING FIELD-SYMBOL(<fs_range_shipto>).
            <fs_range_shipto>-sign = ls_range_shipto-sign.
            <fs_range_shipto>-option = ls_range_shipto-range_option.
            <fs_range_shipto>-low = ls_range_shipto-low.
            <fs_range_shipto>-high = ls_range_shipto-high.
            DATA(lo_filter_node3)  = lo_filter_factory->create_by_range( iv_property_path     = 'SHIP_TO_PARTY'
                                                                         it_range             = lt_range_shipto ).
          ENDLOOP.
        ENDIF.


        lo_filter_node_root = lo_filter_node1.
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

    DATA lt_data TYPE zcl_open_delivery=>tt_delivery_deep.
    DATA ls_parameters TYPE zcl_test_delivery_api=>ty_parameters.
    DATA lt_delivery TYPE zsvc_delivery_api=>tyt_a_outb_delivery_item_type.
    DATA lt_delivery_final TYPE zsvc_delivery_api=>tyt_a_outb_delivery_item_type.
    DATA lv_count_delivery TYPE i.

    APPEND INITIAL LINE TO ls_parameters-filter-range_soldto ASSIGNING FIELD-SYMBOL(<fs_range_soldto>).
    <fs_range_soldto>-sign = 'I'.
    <fs_range_soldto>-range_option = 'EQ'.
    <fs_range_soldto>-low = '17100001'.

    APPEND INITIAL LINE TO ls_parameters-filter-range_shipto ASSIGNING FIELD-SYMBOL(<fs_range_shipto>).
    <fs_range_shipto>-sign = 'I'.
    <fs_range_shipto>-range_option = 'EQ'.
    <fs_range_shipto>-low = '17100001'.

    APPEND INITIAL LINE TO ls_parameters-filter-range_material ASSIGNING FIELD-SYMBOL(<fs_range_material>).
    <fs_range_material>-sign = 'I'.
    <fs_range_material>-range_option = 'EQ'.
    <fs_range_material>-low = 'TG11'.

    WHILE lv_count_delivery < 100.
      IF sy-index = 0.
        ls_parameters-top = 100.
        ls_parameters-skip = 0.
      ELSE.
        ls_parameters-skip = ls_parameters-skip + 100.
      ENDIF.
      CLEAR lt_data.
      zcl_test_delivery_api=>read_delivery( EXPORTING is_parameters = ls_parameters
                                            IMPORTING et_data = lt_data ).
      "filter line items
      CLEAR lt_delivery.
      LOOP AT lt_data INTO DATA(ls_data).
        APPEND LINES OF ls_data-to_delivery_document_item TO lt_delivery.
      ENDLOOP.

      "filter items
      IF ls_parameters-filter-range_material IS NOT INITIAL.
        DELETE lt_delivery WHERE material NOT IN ls_parameters-filter-range_material[].
      ENDIF.

      IF lt_delivery IS NOT INITIAL.
        APPEND LINES OF lt_delivery TO lt_delivery_final.
      ENDIF.

      lv_count_delivery = lines( lt_delivery_final ).
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.
