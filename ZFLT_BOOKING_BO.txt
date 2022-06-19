CLASS zflt_booking_bo DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED
  GLOBAL FRIENDS zflt_booking_bo_ft.

  PUBLIC SECTION.

    INTERFACES zflt_booking_bo_if.

    TYPES t_data TYPE zflt_booking_dao_if=>t_booking_data.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA booking_dao TYPE REF TO zflt_booking_dao_if.

ENDCLASS.

CLASS zflt_booking_bo IMPLEMENTATION.

  METHOD zflt_booking_bo_if~get_booking_id.

    booking_id = me->booking_dao->get_booking_id( ).

  ENDMETHOD.

  METHOD zflt_booking_bo_if~update_data.

    DATA(temp_booking_data) = booking_data.

    DATA(dao_field_flags) = CORRESPONDING zflt_booking_dao_if=>t_field_flags( field_flags ).

    GET TIME STAMP FIELD DATA(last_change_date).
    temp_booking_data-lastchangedat = last_change_date.
    dao_field_flags-lastchangedat = abap_true.

    me->booking_dao->update_data(
      booking_data = temp_booking_data
      field_flags  = dao_field_flags ).

  ENDMETHOD.

  METHOD zflt_booking_bo_if~get_data.

    booking_data = me->booking_dao->get_data( ).

  ENDMETHOD.

  METHOD zflt_booking_bo_if~delete.

    me->booking_dao->delete( ).

  ENDMETHOD.

  METHOD zflt_booking_bo_if~save.

    me->booking_dao->save( ).

  ENDMETHOD.

ENDCLASS.
