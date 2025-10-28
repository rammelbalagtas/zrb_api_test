CLASS lhc_OpenDelivery DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR OpenDelivery RESULT result.

*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR OpenDelivery RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE OpenDelivery.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE OpenDelivery.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE OpenDelivery.

    METHODS read FOR READ
      IMPORTING keys FOR READ OpenDelivery RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK OpenDelivery.
    METHODS getOpenDelivery FOR MODIFY
      IMPORTING keys FOR ACTION OpenDelivery~getOpenDelivery RESULT result.

ENDCLASS.

CLASS lhc_OpenDelivery IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD getOpenDelivery.
    DATA ls_result LIKE LINE OF result.
    IF 1 = 1.
    ENDIF.
*    LOOP AT keys INTO DATA(ls_keys).
*      ls_result-%cid = ls_keys-%cid.
*      MOVE-CORRESPONDING ls_keys-%param TO ls_result-%param.
*      APPEND ls_result TO result.
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCE_OPEN_DELIVERY DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCE_OPEN_DELIVERY IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
