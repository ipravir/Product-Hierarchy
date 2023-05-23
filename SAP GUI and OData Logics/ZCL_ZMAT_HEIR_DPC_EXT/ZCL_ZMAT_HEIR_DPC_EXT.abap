class ZCL_ZMAT_HEIR_DPC_EXT definition
  public
  inheriting from ZCL_ZMAT_HEIR_DPC
  create public .

public section.
protected section.

  methods HEIRARCHYSET_GET_ENTITY
    redefinition .
  methods HEIRARCHYSET_GET_ENTITYSET
    redefinition .
  methods MATIMGSET_GET_ENTITY
    redefinition .
  methods MATIMGSET_GET_ENTITYSET
    redefinition .
  methods MATSINFOSET_GET_ENTITYSET
    redefinition .
  methods MATBUILDSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMAT_HEIR_DPC_EXT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZMAT_HEIR_DPC_EXT->HEIRARCHYSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_REQUEST_OBJECT              TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [<---] ER_ENTITY                      TYPE        ZCL_ZMAT_HEIR_MPC=>TS_HEIRARCHY
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD heirarchyset_get_entity.
    IF it_key_tab IS NOT INITIAL.
      DATA(lo_heirar) = NEW zcl_mat_heirarchy( ).
      IF lo_heirar IS BOUND.
        DATA(lt_entityset) = lo_heirar->get_parent( CONV #( it_key_tab[ 1 ]-value ) ).
        IF lt_entityset IS NOT INITIAL.
          er_entity = lt_entityset[ 1 ].
        ELSE.
          lt_entityset = lo_heirar->get_childs( iv_key = CONV #( it_key_tab[ 1 ]-value )
                                                iv_child_check = abap_true ).
          IF lt_entityset IS NOT INITIAL.
            er_entity = lt_entityset[ 1 ].
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZMAT_HEIR_DPC_EXT->HEIRARCHYSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZMAT_HEIR_MPC=>TT_HEIRARCHY
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD heirarchyset_get_entityset.
    DATA(lo_heirar) = NEW zcl_mat_heirarchy( ).
    IF lo_heirar IS BOUND.
      DATA(lt_filter_so) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
      IF lt_filter_so IS NOT INITIAL.
*----------------------------------------------------------------------*
*&  Reading value from IO_TECH_REQUEST_CONTEXT based on importing
*&  Field name
*----------------------------------------------------------------------*
        READ TABLE lt_filter_so INTO DATA(ls_filter_so) WITH KEY property = 'N_IMAGE'.
        IF sy-subrc EQ 0 AND ls_filter_so-select_options IS NOT INITIAL.
          IF ls_filter_so-select_options[ 1 ]-low EQ 'PRV'.
            et_entityset = lo_heirar->build_node_table( ).
          ELSE.
            et_entityset = lo_heirar->get_childs( iv_key = CONV #( ls_filter_so-select_options[ 1 ]-low ) ).
          ENDIF.
          RETURN.
        ENDIF.
      ENDIF.
      et_entityset = lo_heirar->get_parent( ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZMAT_HEIR_DPC_EXT->MATBUILDSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZMAT_HEIR_MPC=>TT_MATBUILD
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD matbuildset_get_entityset.
    DATA(lo_heirar) = NEW zcl_mat_heirarchy( ).
    IF lo_heirar IS BOUND.
      DATA(lt_filter_so) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
      IF lt_filter_so IS NOT INITIAL.
*----------------------------------------------------------------------*
*&  Reading value from IO_TECH_REQUEST_CONTEXT based on importing
*&  Field name
*----------------------------------------------------------------------*
        READ TABLE lt_filter_so INTO DATA(ls_filter_so) WITH KEY property = 'PRODUCT_ID'.
        IF sy-subrc EQ 0 AND ls_filter_so-select_options IS NOT INITIAL.
          lo_heirar->get_matinfo_for_build( EXPORTING iv_prdha     = CONV #( ls_filter_so-select_options[ 1 ]-low )    " Product Hierarchy
                                         IMPORTING et_materials = et_entityset ).
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZMAT_HEIR_DPC_EXT->MATIMGSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_REQUEST_OBJECT              TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [<---] ER_ENTITY                      TYPE        ZCL_ZMAT_HEIR_MPC=>TS_MATIMG
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD matimgset_get_entity.
    IF it_key_tab IS NOT INITIAL.
      DATA(lo_heirar) = NEW zcl_mat_heirarchy( ).
      IF lo_heirar IS BOUND.
        lo_heirar->get_materials_images( EXPORTING iv_matnr     = CONV #( it_key_tab[ 1 ]-value )    " Product Hierarchy
                                         IMPORTING et_image_data = DATA(lt_entityset) ).
        er_entity = lt_entityset[ 1 ].
      ENDIF.
    ENDIF.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZMAT_HEIR_DPC_EXT->MATIMGSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZMAT_HEIR_MPC=>TT_MATIMG
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD matimgset_get_entityset.
    DATA(lo_heirar) = NEW zcl_mat_heirarchy( ).
    IF lo_heirar IS BOUND.
      DATA(lt_filter_so) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
      IF lt_filter_so IS NOT INITIAL.
*----------------------------------------------------------------------*
*&  Reading value from IO_TECH_REQUEST_CONTEXT based on importing
*&  Field name
*----------------------------------------------------------------------*
        READ TABLE lt_filter_so INTO DATA(ls_filter_so) WITH KEY property = 'NAME'.
        IF sy-subrc EQ 0 AND ls_filter_so-select_options IS NOT INITIAL.
          lo_heirar->get_materials_images( EXPORTING iv_prdha     = CONV #( ls_filter_so-select_options[ 1 ]-low )    " Product Hierarchy
                                           IMPORTING et_image_data = et_entityset ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZMAT_HEIR_DPC_EXT->MATSINFOSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZMAT_HEIR_MPC=>TT_MATSINFO
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD matsinfoset_get_entityset.
    DATA(lo_heirar) = NEW zcl_mat_heirarchy( ).
    IF lo_heirar IS BOUND.
      DATA(lt_filter_so) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
      IF lt_filter_so IS NOT INITIAL.
*----------------------------------------------------------------------*
*&  Reading value from IO_TECH_REQUEST_CONTEXT based on importing
*&  Field name
*----------------------------------------------------------------------*
        READ TABLE lt_filter_so INTO DATA(ls_filter_so) WITH KEY property = 'PRDHA'.
        IF sy-subrc EQ 0 AND ls_filter_so-select_options IS NOT INITIAL.
          lo_heirar->get_materials_info( EXPORTING iv_prdha     = CONV #( ls_filter_so-select_options[ 1 ]-low )    " Product Hierarchy
                                         IMPORTING et_materials = et_entityset ).
          RETURN.
        ENDIF.
      ENDIF.
      et_entityset = lo_heirar->get_parent( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.