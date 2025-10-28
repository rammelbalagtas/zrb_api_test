CLASS zcl_test_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS c_api_key      TYPE string VALUE `2baUSS3WkDjAgLy3914XzxLK32LKCFRO`.
    CONSTANTS c_api_endpoint TYPE string VALUE `https://sandbox.api.sap.com`.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_api IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_business_data TYPE TABLE OF zsvc_product_api=>tys_product_type,
      lt_business_data2 TYPE TABLE OF zsvc_product_api=>tys_product_type,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

*DATA:
* lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
* lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
* lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
* lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
* lt_range_PRODUCT TYPE RANGE OF <element_name>,
* lt_range_PRODUCT_TYPE_2 TYPE RANGE OF <element_name>.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( c_api_endpoint ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        ASSERT lo_http_client IS BOUND.

        lo_http_client->get_http_request( )->set_header_field( i_name  = 'APIKey'
                                                               i_value = c_api_key ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
               EXPORTING
                  is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                      proxy_model_id      = 'ZSVC_PRODUCT_API'
                                                      proxy_model_version = '0001' )
                 io_http_client             = lo_http_client
                 iv_relative_service_root   = '/s4hanacloud/sap/opu/odata4/sap/api_product/srvd_a2x/sap/product/0002/' ).

        "Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'PRODUCT' )->create_request_for_read( ).

        " Create the filter tree
*lo_filter_factory = lo_request->create_filter_factory( ).
*
*lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'PRODUCT'
*                                                        it_range             = lt_range_PRODUCT ).
*lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'PRODUCT_TYPE_2'
*                                                        it_range             = lt_range_PRODUCT_TYPE_2 ).

*lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
*lo_request->set_filter( lo_filter_node_root ).

*        lo_request->set_top( 1000 )->set_skip( 0 ).
        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

        WHILE lo_response->has_next( ).
          lo_response = lo_response->get_next( ).
          CLEAR lt_business_data2.
          lo_response->get_business_data( IMPORTING et_business_data = lt_business_data2 ).
          APPEND LINES OF lt_business_data2 to lt_business_data.
        ENDWHILE.

        IF 1 = 1.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.
      CATCH cx_root INTO DATA(lo_error).

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
