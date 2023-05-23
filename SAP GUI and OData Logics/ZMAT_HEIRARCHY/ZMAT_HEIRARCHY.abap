*&---------------------------------------------------------------------*
*& Report ZMAT_HEIRARCHY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmat_heirarchy.

DATA go_heir TYPE REF TO zcl_mat_heirarchy.

INITIALIZATION.
  IF go_heir IS NOT BOUND.
    go_heir = NEW zcl_mat_heirarchy( ).
  ENDIF.

START-OF-SELECTION.



  CALL SCREEN 9000.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'MENU'.
  SET TITLEBAR 'TITLE'.
  go_heir->pbo( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  go_heir->pai( ).
ENDMODULE.