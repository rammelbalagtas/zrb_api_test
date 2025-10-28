CLASS zcl_test_delivery_api DEFINITION
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



CLASS zcl_test_delivery_api IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF ty_delivery_deep,
             INCLUDE TYPE zsvc_delivery_api=>tys_a_outb_delivery_header_typ,
             to_delivery_document_item TYPE zsvc_delivery_api=>tyt_a_outb_delivery_item_type,
           END OF ty_delivery_deep.

    DATA:
      lt_business_data  TYPE TABLE OF ty_delivery_deep,
      lt_business_data2 TYPE TABLE OF zsvc_delivery_api=>tys_a_outb_delivery_header_typ,
      lo_http_client    TYPE REF TO if_web_http_client,
      lo_client_proxy   TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request        TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response       TYPE REF TO /iwbep/if_cp_response_read_lst.


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
        lo_request->set_select_properties( VALUE #( ( CONV #( 'DELIVERY_DOCUMENT' ) ) ) ).

        DATA: lo_expand_node_root TYPE REF TO /iwbep/if_cp_expand_node,
              lo_expand_node      TYPE REF TO /iwbep/if_cp_expand_node.

        lo_expand_node_root = lo_request->create_expand_node( ).
        lo_expand_node = lo_expand_node_root->add_expand( 'TO_DELIVERY_DOCUMENT_ITEM' ).
        lo_expand_node->set_select_properties( VALUE #( ( CONV #( 'MATERIAL' ) ) ) ).

        lo_request->set_top( 10 )->set_skip( 0 ).

*        DATA ts1 TYPE timestampl.
*        DATA ts2 TYPE timestampl.
*        GET TIME STAMP FIELD ts1.
*        DATA(time1) = cl_abap_context_info=>get_system_time( ).
*
*
*        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).
*
*        WHILE lo_response->has_next( ).
*          lo_response = lo_response->get_next( ).
*          CLEAR lt_business_data2.
*          lo_response->get_business_data( IMPORTING et_business_data = lt_business_data2 ).
*          APPEND LINES OF lt_business_data2 TO lt_business_data.
*        ENDWHILE.
*
*        GET TIME STAMP FIELD ts2.
*        DATA(time2) = cl_abap_context_info=>get_system_time( ).
*        out->write( time1 ).
*        out->write( time2 ).

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
