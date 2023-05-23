class ZCL_MAT_HEIRARCHY definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF typ_s_t179,
        prodh  TYPE  prodh_d,
        stufe  TYPE  prodh_stuf,
        txt    TYPE bezei40,
        key    TYPE tv_nodekey,
        par    TYPE tv_nodekey,
        parent TYPE tv_nodekey,
      END OF   typ_s_t179 .
  types:
    typ_t_t179 TYPE STANDARD TABLE OF typ_s_t179 .

  class-data GV_UCOMM type SY-UCOMM .
  class-data GV_EVENT type TEXT30 .
  class-data GV_NODE_KEY type TV_NODEKEY .
  constants GC_BACK type SY-UCOMM value 'BACK' ##NO_TEXT.
  constants GC_TEST type SY-UCOMM value 'TEST' ##NO_TEXT.

  methods PBO .
  methods PAI .
  methods UPDATE_ID
    importing
      !IV_ID type TV_NODEKEY
      !IV_STUF type PRODH_STUF
      !IV_PRODH type PRODH_D
      !IV_MAIN_LEN type INT4
      !IV_FROM_INDEX type INT4
      !IV_MAIN_PARENT type TV_NODEKEY optional
    changing
      !CT_T179 type TYP_T_T179 .
  methods IS_CHILD
    importing
      !IT_T179 type TYP_T_T179
      !IV_KEY type TV_NODEKEY
    returning
      value(RV_EXIST) type BOOLE_D .
  methods GET_PARENT
    importing
      !IV_KEY type TV_NODEKEY optional
    returning
      value(RT_PARENTS) type SFS_QB_NODE_T .
  methods GET_CHILDS
    importing
      !IV_KEY type TV_NODEKEY
      !IV_CHILD_CHECK type BOOLE_D optional
    returning
      value(RT_CHILDS) type SFS_QB_NODE_T .
  methods BUILD_NODE_TABLE
    importing
      !IV_LEVEL type PRODH_STUF optional
    returning
      value(RT_NODE_TABLE) type SFS_QB_NODE_T .
  methods GET_MATERIALS_INFO
    importing
      !IV_PRDHA type PRODH_D
    exporting
      !ET_MATERIALS type ZCL_ZMAT_HEIR_MPC=>TT_MATSINFO .
  methods GET_MATERIALS_IMAGES
    importing
      !IV_PRDHA type PRODH_D optional
      !IV_MATNR type MATNR optional
    exporting
      !ET_IMAGE_DATA type ZCL_ZMAT_HEIR_MPC=>TT_MATIMG .
  methods GET_MATINFO_FOR_BUILD
    importing
      !IV_PRDHA type PRODH_D
    exporting
      !ET_MATERIALS type ZCL_ZMAT_HEIR_MPC=>TT_MATBUILD .
  PROTECTED SECTION.
private section.

  data GT_HIRARCHY_TABLE type SFS_QB_NODE_T .
  constants GC_MAT_DISP type UI_FUNC value 'GC_LINK_MATS' ##NO_TEXT.
  data GV_PAR_KEY type TV_NODEKEY .
  data GO_TREE type ref to CL_GUI_SIMPLE_TREE .
  data GV_INIT_NO type NUM2 .
  data GO_SPLITTER_CONTAINER type ref to CL_GUI_SPLITTER_CONTAINER .
  data GO_TREE_CONTAINER type ref to CL_GUI_CONTAINER .
  data GO_DETAILS_CONTAINER type ref to CL_GUI_CONTAINER .
  data GO_PICTURE_CONTAINER type ref to CL_GUI_CONTAINER .
  data GO_ALV type ref to CL_GUI_ALV_GRID .
  data GT_MAT_INFO type ZCL_ZMAT_HEIR_MPC=>TT_MATSINFO .
  data GC_MAT_IMG_PATH type TEXT50 value '/SAP/PUBLIC/MAT_IMG/' ##NO_TEXT.
  data GO_PICTURE type ref to CL_GUI_PICTURE .
  constants GC_DEFAULT_MAT_IMG type MATNR value 'DEFAULT' ##NO_TEXT.
  data GV_DEFAULT_IMG_BASE64 type STRING .
  data GV_DEFAULT_IMG_MIME type STRING .

  methods INIT_TREE .
  methods HANDLE_NODE_DOUBLE_CLICK
    for event NODE_DOUBLE_CLICK of CL_GUI_SIMPLE_TREE
    importing
      !NODE_KEY .
  methods HANDLE_EXPAND_NO_CHILDREN
    for event EXPAND_NO_CHILDREN of CL_GUI_SIMPLE_TREE
    importing
      !NODE_KEY .
  methods GET_NEW_PARENT
    returning
      value(RV_ID) type TV_NODEKEY .
  methods GET_HEIRARCHY_RECORDS
    importing
      !IV_LEVEL type PRODH_STUF optional
    exporting
      !ET_HEIRAR type TYP_T_T179 .
  methods GET_NO_OF_MATERIAL_INFO
    importing
      !IT_T179 type TYP_T_T179
    returning
      value(RT_MARA) type MARA_TT .
  methods HANDLE_ITEM_CTMENU_REQUEST
    for event ITEM_CONTEXT_MENU_REQUEST of CL_GUI_ALV_TREE
    importing
      !FIELDNAME
      !MENU
      !NODE_KEY .
  methods INIT_VIEW .
  methods INIT_ALV .
  methods GET_FCAT
    importing
      !IV_TABNAME type TABNAME
    returning
      value(RT_FCAT) type LVC_T_FCAT .
  methods IS_MIME_EXIST
    importing
      !IV_MATNR type MATNR
    returning
      value(RV_EXIST) type BOOLE_D .
  methods GET_MIME_DATA
    importing
      !IV_MATNR type MATNR
    exporting
      value(EV_CONTENT) type XSTRING
      !EV_TYPE type QISRDIMAGE_SUFFIX .
  methods INIT_PICTURE .
  methods HANDLE_ALV_FIELD_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods DISPLAY_MATERIAL_IMAGE
    importing
      !IV_MATNR type MATNR .
ENDCLASS.



CLASS ZCL_MAT_HEIRARCHY IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->BUILD_NODE_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LEVEL                       TYPE        PRODH_STUF(optional)
* | [<-()] RT_NODE_TABLE                  TYPE        SFS_QB_NODE_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD build_node_table.
    DATA: ls_node             TYPE mtreesnode,
          lv_parant_node      TYPE tv_nodekey,
          lv_main_parant_node TYPE tv_nodekey,
          lv_main_len         TYPE int4.

    get_heirarchy_records( EXPORTING iv_level  = iv_level
                           IMPORTING et_heirar = DATA(lt_t179) ).
    IF lt_t179 IS NOT INITIAL.
      LOOP AT lt_t179 INTO DATA(ls_t179) GROUP BY ( stufe = ls_t179-stufe
                                                    index = GROUP INDEX
                                                    size = GROUP SIZE ) ASCENDING INTO DATA(ls_group).
        LOOP AT lt_t179 INTO DATA(ls_t1791) WHERE stufe EQ  ls_group-stufe.
          DATA(lv_new_id) = get_new_parent( ).
          ls_group-index = sy-tabix.
          lv_main_len = strlen( ls_t1791-prodh ).
          IF ls_group-stufe NE 1.
            lv_main_parant_node = ls_t1791-par.
          ENDIF.
          update_id( EXPORTING iv_id       = lv_new_id
                               iv_stuf     = ls_t179-stufe
                               iv_prodh    = ls_t1791-prodh
                               iv_main_len =  lv_main_len
                               iv_from_index = ls_group-index
                               iv_main_parent = lv_main_parant_node
                     CHANGING  ct_t179     = lt_t179 ).
        ENDLOOP.
        CLEAR: gv_par_key.
      ENDLOOP.
      DATA(lt_mara) = get_no_of_material_info( it_t179 = lt_t179 ).
      LOOP AT lt_t179 ASSIGNING FIELD-SYMBOL(<fs_ls_t179>).
        ls_node-node_key = <fs_ls_t179>-key.
        ls_node-isfolder = abap_true.
        ls_node-text = <fs_ls_t179>-txt.
        ls_node-relatkey = <fs_ls_t179>-parent.
        IF is_child( it_t179 = lt_t179 iv_key  = <fs_ls_t179>-key  ) EQ abap_true.
          ls_node-relatship = cl_gui_simple_tree=>relat_last_child.
          ls_node-expander = abap_true.
        ENDIF.
        READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY prdha = <fs_ls_t179>-prodh BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_node-dragdropid = ls_mara-matnr.
        ENDIF.
        ls_node-exp_image = <fs_ls_t179>-prodh.
        APPEND ls_node TO rt_node_table.
        CLEAR: ls_node.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->DISPLAY_MATERIAL_IMAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATNR                       TYPE        MATNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display_material_image.
    TYPES: lt_line(1022) TYPE x.
    CONSTANTS: lc_loop TYPE i VALUE 1022.
    DATA:lt_tab TYPE STANDARD TABLE OF lt_line,
         lv_url TYPE c LENGTH 255.
    IF go_picture IS BOUND.
      lv_url = gc_mat_img_path && iv_matnr.
      get_mime_data( EXPORTING iv_matnr   =   iv_matnr
                     IMPORTING ev_content = DATA(lv_content)
                               ev_type    = DATA(lv_type) ).
      DATA(lv_len) = xstrlen( lv_content ).
      WHILE lv_len GE lc_loop.
        APPEND lv_content(lc_loop) TO lt_tab.
        SHIFT lv_content BY lc_loop PLACES LEFT IN BYTE MODE.
        lv_len = xstrlen( lv_content ).
      ENDWHILE.
      IF lv_len GT 0.
        APPEND lv_content TO lt_tab.
      ENDIF.
      CALL FUNCTION 'DP_CREATE_URL'
        EXPORTING
          type    = 'IMAGE'
          subtype = 'JPG'
        TABLES
          data    = lt_tab
        CHANGING
          url     = lv_url.
      go_picture->load_picture_from_url( url = lv_url ).
      go_picture->set_display_mode( EXPORTING display_mode = go_picture->display_mode_fit ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->GET_CHILDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_KEY                         TYPE        TV_NODEKEY
* | [--->] IV_CHILD_CHECK                 TYPE        BOOLE_D(optional)
* | [<-()] RT_CHILDS                      TYPE        SFS_QB_NODE_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_childs.
    DATA: ls_node    TYPE mtreesnode,
          lt_r_prodh TYPE RANGE OF prodh_d,
          lt_t179    TYPE typ_t_t179,
          lv_count   TYPE i.
    APPEND VALUE #( sign = 'I' option = 'CP' low = iv_key && '*' ) TO lt_r_prodh.

    SELECT m~prodh, m~stufe, t~vtext AS txt FROM t179 AS m
                                     INNER JOIN t179t AS t
                                     ON m~prodh EQ t~prodh
                                     INTO TABLE @lt_t179
                                     WHERE m~prodh IN @lt_r_prodh
                                     AND t~spras = @sy-langu.
    IF sy-subrc EQ 0.
      SORT lt_t179 BY prodh stufe.
      IF iv_child_check EQ abap_false.
        DELETE lt_t179 INDEX 1.
      ENDIF.
      IF lt_t179 IS NOT INITIAL.
        DATA(ls_t1791) = lt_t179[ 1 ].
        DATA(lt_mara) = get_no_of_material_info( it_t179 = lt_t179 ).
        LOOP AT lt_t179 ASSIGNING FIELD-SYMBOL(<fs_ls_t179>) WHERE stufe EQ ls_t1791-stufe.
          REFRESH: lt_r_prodh.
          ls_node-n_image = <fs_ls_t179>-prodh.
          ls_node-text = <fs_ls_t179>-txt.
          APPEND VALUE #( sign = 'I' option = 'CP' low = <fs_ls_t179>-prodh && '*' ) TO lt_r_prodh.
          LOOP AT lt_t179 TRANSPORTING NO FIELDS WHERE prodh IN lt_r_prodh.
            lv_count = lv_count + 1.
            IF lv_count GE 2.
              EXIT.
            ENDIF.
          ENDLOOP.
          IF lv_count GE 2.
            ls_node-isfolder = abap_true.
          ENDIF.
          READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY prdha = <fs_ls_t179>-prodh BINARY SEARCH.
          IF sy-subrc EQ 0.
            ls_node-dragdropid = ls_mara-matnr.
          ENDIF.
          APPEND ls_node TO rt_childs.
          CLEAR: ls_node, lv_count.
        ENDLOOP.
        SORT rt_childs BY text.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->GET_FCAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABNAME                     TYPE        TABNAME
* | [<-()] RT_FCAT                        TYPE        LVC_T_FCAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = iv_tabname
      CHANGING
        ct_fieldcat            = rt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->GET_HEIRARCHY_RECORDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LEVEL                       TYPE        PRODH_STUF(optional)
* | [<---] ET_HEIRAR                      TYPE        TYP_T_T179
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_heirarchy_records.
    DATA: lt_r_stufe TYPE RANGE OF prodh_stuf,
          lt_r_prodh TYPE RANGE OF prodh_d.
    REFRESH: et_heirar.
    IF iv_level IS SUPPLIED AND iv_level IS NOT INITIAL.
      APPEND VALUE #( low = iv_level sign = 'I' option = 'EQ' ) TO lt_r_stufe.
    ENDIF.
    SELECT m~prodh, m~stufe, t~vtext, m~prodh AS key FROM t179 AS m
                                                     INNER JOIN t179t AS t
                                                     ON m~prodh EQ t~prodh
                                                     INTO TABLE @et_heirar
                                                     WHERE m~prodh IN @lt_r_prodh
                                                     AND   m~stufe IN @lt_r_stufe
                                                     AND t~spras = @sy-langu.
    IF sy-subrc EQ 0.
      SORT et_heirar BY prodh stufe.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->GET_MATERIALS_IMAGES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PRDHA                       TYPE        PRODH_D(optional)
* | [--->] IV_MATNR                       TYPE        MATNR(optional)
* | [<---] ET_IMAGE_DATA                  TYPE        ZCL_ZMAT_HEIR_MPC=>TT_MATIMG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_materials_images.
    DATA: lv_length TYPE i,
          lv_base64 TYPE string.
    REFRESH: et_image_data.
    IF iv_prdha IS SUPPLIED.
      SELECT matnr FROM mara
                   INTO TABLE @DATA(lt_mat_info)
                   WHERE prdha EQ @iv_prdha.
    ELSEIF iv_matnr IS SUPPLIED.
      APPEND VALUE #( matnr = iv_matnr ) TO lt_mat_info.
    ENDIF.
    IF sy-subrc EQ 0 AND lt_mat_info IS NOT INITIAL.
      LOOP AT lt_mat_info INTO DATA(ls_mat_info).
        IF is_mime_exist( iv_matnr = ls_mat_info-matnr ) EQ abap_true.
          get_mime_data( EXPORTING iv_matnr   = ls_mat_info-matnr
                         IMPORTING ev_content = DATA(lv_content)
                                   ev_type    = DATA(lv_type) ).
          CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
            EXPORTING
              input  = lv_content
            IMPORTING
              output = lv_base64.
        ELSE.
          IF gv_default_img_base64 IS INITIAL.
            get_mime_data( EXPORTING iv_matnr   = gc_default_mat_img
                           IMPORTING ev_content = lv_content
                                     ev_type    = gv_default_img_mime ).
            CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
              EXPORTING
                input  = lv_content
              IMPORTING
                output = gv_default_img_base64.
          ENDIF.
          lv_base64 = gv_default_img_base64.
          lv_type = gv_default_img_mime.
        ENDIF.
        APPEND VALUE #( name = ls_mat_info-matnr descript = lv_type suffix = lv_base64 ) TO et_image_data.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->GET_MATERIALS_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PRDHA                       TYPE        PRODH_D
* | [<---] ET_MATERIALS                   TYPE        ZCL_ZMAT_HEIR_MPC=>TT_MATSINFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_materials_info.
    REFRESH: et_materials.
    SELECT m~matnr, t~maktx FROM mara AS m
                        INNER JOIN makt AS t
                        ON m~matnr EQ t~matnr
                        INTO TABLE @DATA(lt_mat_info)
                        WHERE m~prdha EQ @iv_prdha
                        AND   t~spras EQ @sy-langu.
    IF sy-subrc EQ 0.
      LOOP AT lt_mat_info INTO DATA(ls_mat_info).
        APPEND VALUE #( matnr = ls_mat_info-matnr  maktx = ls_mat_info-maktx prdha = iv_prdha ) TO et_materials.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->GET_MATINFO_FOR_BUILD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PRDHA                       TYPE        PRODH_D
* | [<---] ET_MATERIALS                   TYPE        ZCL_ZMAT_HEIR_MPC=>TT_MATBUILD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_matinfo_for_build.
    REFRESH: et_materials.
    SELECT m~matnr, t~maktx FROM mara AS m
                        INNER JOIN makt AS t
                        ON m~matnr EQ t~matnr
                        INTO TABLE @DATA(lt_mat_info)
                        WHERE m~prdha EQ @iv_prdha
                        AND   t~spras EQ @sy-langu.
    IF sy-subrc EQ 0.
      LOOP AT lt_mat_info INTO DATA(ls_mat_info).
        get_materials_images( EXPORTING iv_matnr  = ls_mat_info-matnr
                              IMPORTING et_image_data = DATA(lt_mat_image) ).
        IF lt_mat_image IS NOT INITIAL.
          DATA(ls_mat_img) = lt_mat_image[ 1 ].
        ENDIF.
        APPEND VALUE #( product_id = ls_mat_info-matnr  content_url = ls_mat_info-maktx mime_type = ls_mat_img-descript content_base64 = ls_mat_img-suffix ) TO et_materials.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->GET_MIME_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATNR                       TYPE        MATNR
* | [<---] EV_CONTENT                     TYPE        XSTRING
* | [<---] EV_TYPE                        TYPE        QISRDIMAGE_SUFFIX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_mime_data.
    CLEAR: ev_content, ev_type.
    DATA(lv_url) = gc_mat_img_path && iv_matnr.
    cl_mime_repository_api=>get_api( )->get( EXPORTING i_url = CONV #( lv_url )
                                             IMPORTING e_content = ev_content
                                                       e_mime_type = ev_type
                                             EXCEPTIONS parameter_missing  = 1
                                                        error_occured = 2
                                                        not_found = 3
                                                        permission_failure = 4 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->GET_NEW_PARENT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        TV_NODEKEY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_new_parent.
    DATA lv_int TYPE int4.
    lv_int = gv_par_key.
    DATA(lv_mod) = lv_int MOD 26.
    TRY.
        DATA(lv_count) = lv_int / 26.
        IF lv_count LT 0.
          rv_id = sy-abcde+25(1).
        ENDIF.
      CATCH cx_sy_zerodivide.
        lv_count = gv_par_key - 25.
    ENDTRY.
    IF lv_count EQ 0.
      rv_id = sy-abcde+lv_mod(1).
    ELSE.
      rv_id = sy-abcde+lv_mod(1) && lv_count.
    ENDIF.
    gv_par_key = gv_par_key + 1.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->GET_NO_OF_MATERIAL_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_T179                        TYPE        TYP_T_T179
* | [<-()] RT_MARA                        TYPE        MARA_TT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_NO_OF_MATERIAL_INFO.
    IF it_t179 IS NOT INITIAL.
      SELECT matnr, prdha FROM mara
                          INTO TABLE @DATA(lt_mara)
                          FOR ALL ENTRIES IN @it_t179
                          WHERE prdha EQ @it_t179-prodh.
      IF sy-subrc EQ 0.
        SORT lt_mara BY prdha.
        LOOP AT lt_mara INTO DATA(ls_mara) GROUP BY ( prdha = ls_mara-prdha
                                                      index = GROUP INDEX
                                                      size = GROUP SIZE ) ASCENDING INTO DATA(ls_group).
          APPEND VALUE #( matnr = ls_group-size prdha = ls_group-prdha ) TO rt_mara.
        ENDLOOP.
        SORT rt_mara BY prdha.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->GET_PARENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_KEY                         TYPE        TV_NODEKEY(optional)
* | [<-()] RT_PARENTS                     TYPE        SFS_QB_NODE_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_parent.
    DATA: ls_node    TYPE mtreesnode,
          lt_r_prodh TYPE RANGE OF prodh_d,
          lt_t179    TYPE typ_t_t179.
    IF iv_key IS SUPPLIED AND iv_key IS NOT INITIAL.
      APPEND VALUE #( sign = 'I' option = 'CP' low = iv_key && '*' ) TO lt_r_prodh.
    ENDIF.
    SELECT m~prodh, m~stufe, t~vtext AS txt FROM t179 AS m
                                     INNER JOIN t179t AS t
                                     ON m~prodh EQ t~prodh
                                     INTO TABLE @lt_t179
                                     WHERE m~prodh IN @lt_r_prodh
                                     AND t~spras = @sy-langu.
    IF sy-subrc EQ 0.
      SORT lt_t179 BY prodh stufe.
      DATA(lt_mara) = get_no_of_material_info( it_t179 = lt_t179 ).
      LOOP AT lt_t179 ASSIGNING FIELD-SYMBOL(<fs_ls_t179>) WHERE stufe EQ 1.
        REFRESH: lt_r_prodh.
        ls_node-n_image = <fs_ls_t179>-prodh.
        ls_node-text = <fs_ls_t179>-txt.
        APPEND VALUE #( sign = 'I' option = 'CP' low = <fs_ls_t179>-prodh && '*' ) TO lt_r_prodh.
        LOOP AT lt_t179 TRANSPORTING NO FIELDS WHERE prodh IN lt_r_prodh.
          ls_node-relatship = ls_node-relatship + 1.
        ENDLOOP.
        IF ls_node-relatship GE 2.
          ls_node-isfolder = abap_true.
        ENDIF.
        READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY prdha = <fs_ls_t179>-prodh BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_node-dragdropid = ls_mara-matnr.
        ENDIF.
        APPEND ls_node TO rt_parents.
        CLEAR: ls_node.
      ENDLOOP.
      SORT rt_parents BY text.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->HANDLE_ALV_FIELD_DOUBLE_CLICK
* +-------------------------------------------------------------------------------------------------+
* | [--->] E_ROW                          LIKE
* | [--->] E_COLUMN                       LIKE
* | [--->] ES_ROW_NO                      LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_alv_field_double_click.
    READ TABLE gt_mat_info INTO DATA(ls_mat_info) INDEX es_row_no-row_id.
    IF sy-subrc EQ 0.
      IF is_mime_exist( iv_matnr = |{ ls_mat_info-matnr ALPHA = OUT }| ) EQ abap_true.
        display_material_image( iv_matnr = |{ ls_mat_info-matnr ALPHA = OUT }|  ).
      else.
        display_material_image( iv_matnr = |{ gc_default_mat_img ALPHA = OUT }|  ).
*        go_picture->clear_picture( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->HANDLE_EXPAND_NO_CHILDREN
* +-------------------------------------------------------------------------------------------------+
* | [--->] NODE_KEY                       LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_expand_no_children.
    DATA: lt_node_table TYPE STANDARD TABLE OF mtreesnode.
    gv_event = 'EXPAND_NO_CHILDREN'.
    gv_node_key = node_key.
    IF node_key = 'Child1'.                                 "#EC NOTEXT
      APPEND VALUE: #( node_key = 'New1' relatkey = 'Child1' relatship = cl_gui_simple_tree=>relat_last_child isfolder = space text = 'New1' ) TO lt_node_table,
      #( node_key = 'New2' relatkey = 'Child1' relatship = cl_gui_simple_tree=>relat_last_child n_image = '@10@' expander = space text = 'New2' ) TO lt_node_table.
      CALL METHOD go_tree->add_nodes
        EXPORTING
          table_structure_name           = 'MTREESNODE'
          node_table                     = lt_node_table
        EXCEPTIONS
          failed                         = 1
          error_in_node_table            = 2
          dp_error                       = 3
          table_structure_name_not_found = 4
          OTHERS                         = 5.
      IF sy-subrc EQ 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->HANDLE_ITEM_CTMENU_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] FIELDNAME                      LIKE
* | [--->] MENU                           LIKE
* | [--->] NODE_KEY                       LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_item_ctmenu_request.
    menu->add_function( EXPORTING fcode = gc_mat_disp    " Function Code
                                  text  = CONV #( TEXT-001 )      " Function text
                                  icon  = '@A6@' ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->HANDLE_NODE_DOUBLE_CLICK
* +-------------------------------------------------------------------------------------------------+
* | [--->] NODE_KEY                       LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_node_double_click.
    READ TABLE gt_hirarchy_table INTO DATA(ls_hiearchy_table) WITH KEY node_key = node_key BINARY SEARCH.
    IF sy-subrc EQ 0.
      get_materials_info( EXPORTING iv_prdha    = CONV #( ls_hiearchy_table-exp_image )    " Product Hierarchy
                          IMPORTING et_materials = gt_mat_info ).
      IF go_alv IS BOUND.
        go_alv->refresh_table_display( ).
        cl_gui_cfw=>set_new_ok_code( 'OK' ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->INIT_ALV
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init_alv.
    IF go_alv IS NOT BOUND.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent          = go_details_container    " Parent Container
        EXCEPTIONS
          error_cntl_create = 1
          error_cntl_init   = 2
          error_cntl_link   = 3
          error_dp_create   = 4
          OTHERS            = 5.
      IF sy-subrc EQ 0.
        DATA(lt_fcat) = get_fcat( iv_tabname = 'TXW_MAT' ).
        LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<fs_ls_fcat>).
          IF <fs_ls_fcat>-fieldname EQ 'MAKTX' OR <fs_ls_fcat>-fieldname EQ 'MATNR'.
            CONTINUE.
          ELSE.
            <fs_ls_fcat>-no_out = abap_true.
          ENDIF.
        ENDLOOP.
        SET HANDLER : handle_alv_field_double_click FOR go_alv.
        CALL METHOD go_alv->set_table_for_first_display
          CHANGING
            it_outtab                     = gt_mat_info
            it_fieldcatalog               = lt_fcat
          EXCEPTIONS
            invalid_parameter_combination = 1
            program_error                 = 2
            too_many_lines                = 3
            OTHERS                        = 4.
        IF sy-subrc EQ 0.
        ENDIF.
      ENDIF.
    ENDIF.
    go_alv->refresh_table_display( ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->INIT_PICTURE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init_picture.
    IF go_picture_container IS BOUND.
      CREATE OBJECT go_picture
        EXPORTING
          parent = go_picture_container   " Parent Container
        EXCEPTIONS
          error  = 1
          OTHERS = 2.
      IF sy-subrc EQ 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->INIT_TREE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init_tree.
    DATA: lt_events     TYPE cntl_simple_events.
    IF go_tree IS NOT BOUND.
      init_view( ).
      CREATE OBJECT go_tree
        EXPORTING
          parent                      = go_tree_container
          node_selection_mode         = cl_gui_simple_tree=>node_sel_mode_single
        EXCEPTIONS
          lifetime_error              = 1
          cntl_system_error           = 2
          create_error                = 3
          failed                      = 4
          illegal_node_selection_mode = 5.
      IF sy-subrc EQ 0.
        APPEND VALUE: #( eventid = cl_gui_simple_tree=>eventid_node_double_click appl_event = abap_true ) TO lt_events,
                      #( eventid = cl_gui_simple_tree=>eventid_expand_no_children appl_event = abap_true ) TO lt_events.
*                      #( eventid = cl_gui_column_tree=>eventid_item_context_menu_req appl_event = abap_true ) TO lt_events.
        CALL METHOD go_tree->set_registered_events
          EXPORTING
            events                    = lt_events
          EXCEPTIONS
            cntl_error                = 1
            cntl_system_error         = 2
            illegal_event_combination = 3.
        IF sy-subrc EQ 0.
          SET HANDLER : handle_node_double_click FOR go_tree,
                        handle_expand_no_children FOR go_tree.
*                        handle_item_ctmenu_request FOR go_tree.
          gt_hirarchy_table = build_node_table( ).
          CALL METHOD go_tree->add_nodes
            EXPORTING
              table_structure_name           = 'MTREESNODE'
              node_table                     = gt_hirarchy_table
            EXCEPTIONS
              failed                         = 1
              error_in_node_table            = 2
              dp_error                       = 3
              table_structure_name_not_found = 4
              OTHERS                         = 5.
          IF sy-subrc EQ 0.
            SORT gt_hirarchy_table BY node_key.
            init_alv( ).
            init_picture( ).
            RETURN.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->INIT_VIEW
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init_view.
    IF go_splitter_container IS NOT BOUND.
      CREATE OBJECT go_splitter_container
        EXPORTING
          parent            = cl_gui_custom_container=>default_screen    " Parent Container
          rows              = 1    " Number of Rows to be displayed
          columns           = 3    " Number of Columns to be Displayed
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2
          OTHERS            = 3.
      IF sy-subrc EQ 0.
        go_tree_container    =  go_splitter_container->get_container( row = 1 column = 1 ).
        go_details_container =  go_splitter_container->get_container( row = 1 column = 2 ).
        go_picture_container =  go_splitter_container->get_container( row = 1 column = 3 ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->IS_CHILD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_T179                        TYPE        TYP_T_T179
* | [--->] IV_KEY                         TYPE        TV_NODEKEY
* | [<-()] RV_EXIST                       TYPE        BOOLE_D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_child.
    DATA lv_loop TYPE i.
    rv_exist = abap_false.
    TRY.
        DATA(ls_info) = it_t179[ parent = iv_key ].
        IF ls_info IS NOT INITIAL.
          rv_exist = abap_true.
          RETURN.
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAT_HEIRARCHY->IS_MIME_EXIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATNR                       TYPE        MATNR
* | [<-()] RV_EXIST                       TYPE        BOOLE_D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_mime_exist.
    DATA: lo_mime_repository TYPE REF TO if_mr_api.
    DATA(lv_url) = gc_mat_img_path && iv_matnr.
    lo_mime_repository = cl_mime_repository_api=>get_api( ).
    lo_mime_repository->get( EXPORTING i_url                  = CONV #( lv_url )    " Object URL
                             EXCEPTIONS parameter_missing      = 1
                                        error_occured          = 2
                                        not_found              = 3
                                        permission_failure     = 4
                                        OTHERS                 = 5 ).
    IF sy-subrc = 0.
      " MIME exists
      rv_exist = abap_true.
    ELSE.
      " MIME does not exist
      rv_exist = abap_false.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->PAI
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD pai.
    DATA: return_code TYPE i.
    cl_gui_cfw=>dispatch( IMPORTING return_code = DATA(lv_return_code) ).
    IF lv_return_code <> cl_gui_cfw=>rc_noevent.
      CLEAR gv_ucomm.
      EXIT.
    ENDIF.
    CASE gv_ucomm.
      WHEN gc_test.
        CALL METHOD go_tree->expand_node
          EXPORTING
            node_key = 'New1'.
      WHEN gc_back.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR gv_ucomm.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->PBO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD pbo.
    IF go_tree IS NOT BOUND.
      init_tree( ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAT_HEIRARCHY->UPDATE_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        TV_NODEKEY
* | [--->] IV_STUF                        TYPE        PRODH_STUF
* | [--->] IV_PRODH                       TYPE        PRODH_D
* | [--->] IV_MAIN_LEN                    TYPE        INT4
* | [--->] IV_FROM_INDEX                  TYPE        INT4
* | [--->] IV_MAIN_PARENT                 TYPE        TV_NODEKEY(optional)
* | [<-->] CT_T179                        TYPE        TYP_T_T179
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_id.
    LOOP AT ct_t179 ASSIGNING FIELD-SYMBOL(<fs_ls_t179>) FROM iv_from_index.
      IF <fs_ls_t179>-prodh+0(iv_main_len) NE iv_prodh.
        RETURN.
      ENDIF.
      DATA(lv_len) = strlen( <fs_ls_t179>-prodh ) - iv_main_len.
      IF lv_len EQ 0.
        <fs_ls_t179>-key = iv_main_parent && iv_id.
      ELSE.
        <fs_ls_t179>-key = iv_main_parent && iv_id && <fs_ls_t179>-prodh+iv_main_len(lv_len).
      ENDIF.
      <fs_ls_t179>-par = iv_main_parent && iv_id.
      IF iv_main_parent IS NOT INITIAL.
        <fs_ls_t179>-parent = iv_main_parent.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.