CLASS zcl_test_salesorder_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS c_api_key      TYPE string VALUE `AWDAvmzST6MTgpWKBfGz5lCoxW2Rtgc2`.
    CONSTANTS c_api_endpoint TYPE string VALUE `https://sandbox.api.sap.com`.

    CLASS-METHODS: read_sales_order IMPORTING is_parameters TYPE zcl_open_delivery=>ty_parameters
                                    EXPORTING et_data       TYPE ANY TABLE.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_test_salesorder_api IMPLEMENTATION.

  METHOD read_sales_order.

    DATA:
      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request      TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response     TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory    TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_root  TYPE REF TO /iwbep/if_cp_filter_node,
      lt_range_SALES_ORDER TYPE RANGE OF zsvc_salesorder_api=>tys_sales_order_type-sales_order.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( c_api_endpoint ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        ASSERT lo_http_client IS BOUND.

        lo_http_client->get_http_request( )->set_header_field( i_name  = 'APIKey'
                                                               i_value = c_api_key ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSVC_SALESORDER_API'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/s4hanacloud/sap/opu/odata4/sap/api_salesorder/srvd_a2x/sap/salesorder/0001/' ).


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'SALES_ORDER_ITEM' )->create_request_for_read( ).
        lo_request->set_select_properties( VALUE #( ( CONV #( 'SALES_ORDER' ) )
                                                    ( CONV #( 'SALES_ORDER_ITEM' ) )
                                                    ( CONV #( 'REQUESTED_QUANTITY' ) )
                                                    ( CONV #( 'NET_AMOUNT' ) ) ) ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).
        IF is_parameters-input-range_sales_order IS NOT INITIAL.
          LOOP AT is_parameters-input-range_sales_order INTO DATA(ls_range_sales_order).
            APPEND INITIAL LINE TO lt_range_SALES_ORDER ASSIGNING FIELD-SYMBOL(<fs_range_sales_order>).
            <fs_range_sales_order>-sign = ls_range_sales_order-sign.
            <fs_range_sales_order>-option = ls_range_sales_order-range_option.
            <fs_range_sales_order>-low = ls_range_sales_order-low.
            <fs_range_sales_order>-high = ls_range_sales_order-high.
          ENDLOOP.
          DATA(lo_filter_node1)  = lo_filter_factory->create_by_range( iv_property_path     = 'SALES_ORDER'
                                                                       it_range             = lt_range_SALES_ORDER ).
        ENDIF.
        lo_filter_node_root = lo_filter_node1.
        lo_request->set_filter( lo_filter_node_root ).

        "Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = et_data ).

*        WHILE lo_response->has_next( ).
*          lo_response = lo_response->get_next( ).
*          CLEAR lt_data_temp.
*          lo_response->get_business_data( IMPORTING et_business_data = lt_data_temp ).
*          IF lt_data_temp IS NOT INITIAL.
*            APPEND LINES OF lt_data_temp TO et_data.
*          ELSE.
*            EXIT.
*          ENDIF.
*        ENDWHILE.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception
        IF 1 = 1.
        ENDIF.

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.


  ENDMETHOD.
ENDCLASS.
