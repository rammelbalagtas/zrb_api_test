CLASS zcl_open_delivery DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_delivery_deep,
             "! ActualDeliveryRoute
             actual_delivery_route      TYPE c LENGTH 6,
             "! Shippinglocationtimezone
             shippinglocationtimezone   TYPE c LENGTH 6,
             "! ActualGoodsMovementDate
             actual_goods_movement_date TYPE timestampl,
             "! Receivinglocationtimezone
             receivinglocationtimezone  TYPE c LENGTH 6,
             "! ActualGoodsMovementTime
             actual_goods_movement_time TYPE timn,
             "! BillingDocumentDate
             billing_document_date      TYPE timestampl,
             "! BillOfLading
             bill_of_lading             TYPE c LENGTH 35,
             "! CompleteDeliveryIsDefined
             complete_delivery_is_defin TYPE abap_bool,
             "! ConfirmationTime
             confirmation_time          TYPE timn,
             "! CreatedByUser
             created_by_user            TYPE c LENGTH 12,
             "! CreationDate
             creation_date              TYPE timestampl,
             "! CreationTime
             creation_time              TYPE timn,
             "! CustomerGroup
             customer_group             TYPE c LENGTH 2,
             "! DeliveryBlockReason
             delivery_block_reason      TYPE c LENGTH 2,
             "! DeliveryDate
             delivery_date              TYPE timestampl,
             "! <em>Key property</em> DeliveryDocument
             delivery_document          TYPE c LENGTH 10,
             "! DeliveryDocumentBySupplier
             delivery_document_by_suppl TYPE c LENGTH 35,
             "! DeliveryDocumentType
             delivery_document_type     TYPE c LENGTH 4,
             "! DeliveryIsInPlant
             delivery_is_in_plant       TYPE abap_bool,
             "! DeliveryPriority
             delivery_priority          TYPE c LENGTH 2,
             "! DeliveryTime
             delivery_time              TYPE timn,
             "! DeliveryVersion
             delivery_version           TYPE c LENGTH 4,
             "! DepreciationPercentage
             depreciation_percentage    TYPE p LENGTH 3 DECIMALS 2,
             "! DistrStatusByDecentralizedWrhs
             distr_status_by_decentrali TYPE c LENGTH 1,
             "! DocumentDate
             document_date              TYPE timestampl,
             "! ExternalIdentificationType
             external_identification_ty TYPE c LENGTH 1,
             "! ExternalTransportSystem
             external_transport_system  TYPE c LENGTH 5,
             "! FactoryCalendarByCustomer
             factory_calendar_by_custom TYPE c LENGTH 2,
             "! GoodsIssueOrReceiptSlipNumber
             goods_issue_or_receipt_sli TYPE c LENGTH 10,
             "! GoodsIssueTime
             goods_issue_time           TYPE timn,
             "! HandlingUnitInStock
             handling_unit_in_stock     TYPE c LENGTH 1,
             "! HdrGeneralIncompletionStatus
             hdr_general_incompletion_s TYPE c LENGTH 1,
             "! HdrGoodsMvtIncompletionStatus
             hdr_goods_mvt_incompletion TYPE c LENGTH 1,
             "! HeaderBillgIncompletionStatus
             header_billg_incompletion  TYPE c LENGTH 1,
             "! HeaderBillingBlockReason
             header_billing_block_reaso TYPE c LENGTH 2,
             "! HeaderDelivIncompletionStatus
             header_deliv_incompletion  TYPE c LENGTH 1,
             "! HeaderGrossWeight
             header_gross_weight        TYPE p LENGTH 8 DECIMALS 3,
             "! HeaderNetWeight
             header_net_weight          TYPE p LENGTH 8 DECIMALS 3,
             "! HeaderPackingIncompletionSts
             header_packing_incompletio TYPE c LENGTH 1,
             "! HeaderPickgIncompletionStatus
             header_pickg_incompletion  TYPE c LENGTH 1,
             "! HeaderVolume
             header_volume              TYPE p LENGTH 8 DECIMALS 3,
             "! HeaderVolumeUnit
             header_volume_unit         TYPE c LENGTH 3,
             "! HeaderWeightUnit
             header_weight_unit         TYPE c LENGTH 3,
             "! IncotermsClassification
             incoterms_classification   TYPE c LENGTH 3,
             "! IncotermsTransferLocation
             incoterms_transfer_locatio TYPE c LENGTH 28,
             "! IntercompanyBillingDate
             intercompany_billing_date  TYPE timestampl,
             "! InternalFinancialDocument
             internal_financial_documen TYPE c LENGTH 10,
             "! IsDeliveryForSingleWarehouse
             is_delivery_for_single_war TYPE c LENGTH 1,
             "! IsExportDelivery
             is_export_delivery         TYPE c LENGTH 1,
             "! LastChangeDate
             last_change_date           TYPE timestampl,
             "! LastChangedByUser
             last_changed_by_user       TYPE c LENGTH 12,
             "! LoadingDate
             loading_date               TYPE timestampl,
             "! LoadingPoint
             loading_point              TYPE c LENGTH 2,
             "! LoadingTime
             loading_time               TYPE timn,
             "! MeansOfTransport
             means_of_transport         TYPE c LENGTH 20,
             "! MeansOfTransportRefMaterial
             means_of_transport_ref_mat TYPE c LENGTH 40,
             "! MeansOfTransportType
             means_of_transport_type    TYPE c LENGTH 4,
             "! OrderCombinationIsAllowed
             order_combination_is_allow TYPE abap_bool,
             "! OrderID
             order_id                   TYPE c LENGTH 12,
             "! OverallDelivConfStatus
             overall_deliv_conf_status  TYPE c LENGTH 1,
             "! OverallDelivReltdBillgStatus
             overall_deliv_reltd_billg  TYPE c LENGTH 1,
             "! OverallGoodsMovementStatus
             overall_goods_movement_sta TYPE c LENGTH 1,
             "! OverallIntcoBillingStatus
             overall_intco_billing_stat TYPE c LENGTH 1,
             "! OverallPackingStatus
             overall_packing_status     TYPE c LENGTH 1,
             "! OverallPickingConfStatus
             overall_picking_conf_statu TYPE c LENGTH 1,
             "! OverallPickingStatus
             overall_picking_status     TYPE c LENGTH 1,
             "! OverallProofOfDeliveryStatus
             overall_proof_of_delivery  TYPE c LENGTH 1,
             "! OverallSDProcessStatus
             overall_sdprocess_status   TYPE c LENGTH 1,
             "! OverallWarehouseActivityStatus
             overall_warehouse_activity TYPE c LENGTH 1,
             "! OvrlItmDelivIncompletionSts
             ovrl_itm_deliv_incompletio TYPE c LENGTH 1,
             "! OvrlItmGdsMvtIncompletionSts
             ovrl_itm_gds_mvt_incomplet TYPE c LENGTH 1,
             "! OvrlItmGeneralIncompletionSts
             ovrl_itm_general_incomplet TYPE c LENGTH 1,
             "! OvrlItmPackingIncompletionSts
             ovrl_itm_packing_incomplet TYPE c LENGTH 1,
             "! OvrlItmPickingIncompletionSts
             ovrl_itm_picking_incomplet TYPE c LENGTH 1,
             "! PaymentGuaranteeProcedure
             payment_guarantee_procedur TYPE c LENGTH 6,
             "! PickedItemsLocation
             picked_items_location      TYPE c LENGTH 20,
             "! PickingDate
             picking_date               TYPE timestampl,
             "! PickingTime
             picking_time               TYPE timn,
             "! PlannedGoodsIssueDate
             planned_goods_issue_date   TYPE timestampl,
             "! ProofOfDeliveryDate
             proof_of_delivery_date     TYPE timestampl,
             "! ProposedDeliveryRoute
             proposed_delivery_route    TYPE c LENGTH 6,
             "! ReceivingPlant
             receiving_plant            TYPE c LENGTH 4,
             "! RouteSchedule
             route_schedule             TYPE c LENGTH 10,
             "! SalesDistrict
             sales_district             TYPE c LENGTH 6,
             "! SalesOffice
             sales_office               TYPE c LENGTH 4,
             "! SalesOrganization
             sales_organization         TYPE c LENGTH 4,
             "! SDDocumentCategory
             sddocument_category        TYPE c LENGTH 4,
             "! ShipmentBlockReason
             shipment_block_reason      TYPE c LENGTH 2,
             "! ShippingCondition
             shipping_condition         TYPE c LENGTH 2,
             "! ShippingPoint
             shipping_point             TYPE c LENGTH 4,
             "! ShippingType
             shipping_type              TYPE c LENGTH 2,
             "! ShipToParty
             ship_to_party              TYPE c LENGTH 10,
             "! SoldToParty
             sold_to_party              TYPE c LENGTH 10,
             "! SpecialProcessingCode
             special_processing_code    TYPE c LENGTH 4,
             "! StatisticsCurrency
             statistics_currency        TYPE c LENGTH 5,
             "! Supplier
             supplier                   TYPE c LENGTH 10,
             "! TotalBlockStatus
             total_block_status         TYPE c LENGTH 1,
             "! TotalCreditCheckStatus
             total_credit_check_status  TYPE c LENGTH 1,
             "! TotalNumberOfPackage
             total_number_of_package    TYPE c LENGTH 5,
             "! TransactionCurrency
             transaction_currency       TYPE c LENGTH 5,
             "! TransportationGroup
             transportation_group       TYPE c LENGTH 4,
             "! TransportationPlanningDate
             transportation_planning_da TYPE timestampl,
             "! TransportationPlanningStatus
             transportation_planning_st TYPE c LENGTH 1,
             "! TransportationPlanningTime
             transportation_planning_ti TYPE timn,
             "! UnloadingPointName
             unloading_point_name       TYPE c LENGTH 25,
             "! Warehouse
             warehouse                  TYPE c LENGTH 3,
             "! WarehouseGate
             warehouse_gate             TYPE c LENGTH 3,
             "! WarehouseStagingArea
             warehouse_staging_area     TYPE c LENGTH 10,
             "! odata.etag
             etag                       TYPE string,
             to_delivery_document_item  TYPE zsvc_delivery_api=>tyt_a_outb_delivery_item_type,
           END OF ty_delivery_deep,

           tt_delivery_deep TYPE STANDARD TABLE OF ty_delivery_deep.

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

    TYPES: BEGIN OF ty_input,
             skiptoken         TYPE i,
             salesoff          TYPE c LENGTH 4,
             plant             TYPE c LENGTH 4,
             salesorg          TYPE c LENGTH 4,
             distrchan         TYPE c LENGTH 2,
             division          TYPE c LENGTH 2,
             range_soldto      TYPE STANDARD TABLE OF ty_range_soldto WITH DEFAULT KEY,
             range_shipto      TYPE STANDARD TABLE OF ty_range_shipto WITH DEFAULT KEY,
             range_material    TYPE STANDARD TABLE OF ty_range_material WITH DEFAULT KEY,
             range_delivery    TYPE STANDARD TABLE OF ty_range_delivery WITH DEFAULT KEY,
             range_sales_order TYPE STANDARD TABLE OF ty_range_sales_order WITH DEFAULT KEY,
             range_bill_block  TYPE STANDARD TABLE OF ty_range_bill_block WITH DEFAULT KEY,
           END OF ty_input.

    TYPES: BEGIN OF ty_result,
             salesoff      TYPE c LENGTH 4,
             soldto        TYPE c LENGTH 10,
             shipto        TYPE c LENGTH 10,
             delivery      TYPE c LENGTH 10,
             delivery_item TYPE c LENGTH 4,
             material      TYPE c LENGTH 40,
             sloc          TYPE c LENGTH 4,
             sales_order   TYPE c LENGTH 10,
             dlv_qty       TYPE p LENGTH 13 DECIMALS 0,
             dlv_type      TYPE c LENGTH 4,
             dlv_value     TYPE p LENGTH 13 DECIMALS 2,
             plant         TYPE c LENGTH 4,
             salesorg      TYPE c LENGTH 4,
             distrchan     TYPE c LENGTH 2,
             division      TYPE c LENGTH 2,
           END OF ty_result,
           tt_result TYPE STANDARD TABLE OF ty_result WITH DEFAULT KEY.

    CLASS-METHODS: get_open_delivery IMPORTING is_input TYPE ty_input EXPORTING et_result TYPE tt_result.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_open_delivery IMPLEMENTATION.
  METHOD get_open_delivery.
    DATA lt_data TYPE tt_delivery_deep.
    DATA ls_parameters TYPE zcl_test_delivery_api=>ty_parameters.
    ls_parameters-top = 100.
    ls_parameters-skip = 0.
    zcl_test_delivery_api=>read_delivery( EXPORTING is_parameters = ls_parameters
                                          IMPORTING et_data = lt_data ).
  ENDMETHOD.
ENDCLASS.
