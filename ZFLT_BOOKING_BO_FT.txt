CLASS zflt_booking_bo_ft DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zflt_booking_bo_ft_if.

    CLASS-METHODS get_factory
      RETURNING VALUE(r_booking_bo_ft) TYPE REF TO zflt_booking_bo_ft_if.

  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA factory TYPE REF TO zflt_booking_bo_ft.

    TYPES:
      BEGIN OF booking_bo,
        booking_id TYPE string,
        booking_bo TYPE REF TO zflt_booking_bo_if,
      END OF booking_bo.

    DATA buffer_bo_list TYPE STANDARD TABLE OF booking_bo.

ENDCLASS.

CLASS zflt_booking_bo_ft IMPLEMENTATION.

  METHOD get_factory.

    IF factory IS INITIAL.
      factory = NEW zflt_booking_bo_ft( ).
    ENDIF.

    r_booking_bo_ft = factory.

  ENDMETHOD.

  METHOD zflt_booking_bo_ft_if~check_booking_exists.

    booking_exists_ind = zflt_booking_dao_ft=>get_factory( )->check_exists( booking_id ).

  ENDMETHOD.

  METHOD zflt_booking_bo_ft_if~create_booking_bo.

    DATA(booking_bo) = NEW zflt_booking_bo( ).

    DATA(last_booking_no) = zflt_booking_dao_ft=>get_factory( )->get_last_booking_id( ).

    DATA(temp_booking_data) = booking_data.

    temp_booking_data-booking = last_booking_no + 1.

    GET TIME STAMP FIELD DATA(current_timestamp).
    temp_booking_data-lastchangedat = current_timestamp.

    booking_bo->booking_dao = zflt_booking_dao_ft=>get_factory( )->create_dao( temp_booking_data ).

    APPEND
      VALUE #(
         booking_id  = booking_data-booking
         booking_bo = booking_bo )
       TO buffer_bo_list.

    return_booking_bo = booking_bo.

  ENDMETHOD.

  METHOD zflt_booking_bo_ft_if~get_booking_bo_by_id.

    READ TABLE buffer_bo_list
      WITH KEY booking_id = booking_id
      ASSIGNING FIELD-SYMBOL(<buffer_instance>).

    IF sy-subrc = 0.

      return_booking_bo = <buffer_instance>-booking_bo.
      RETURN.

    ENDIF.

    DATA(booking_bo) = NEW zflt_booking_bo( ).

    booking_bo->booking_dao = zflt_booking_dao_ft=>get_factory( )->get_dao( booking_id ).

    IF buffer_ind = abap_true.

      APPEND VALUE #(
        booking_id  = booking_id
        booking_bo = booking_bo )
        TO buffer_bo_list.

    ENDIF.

    return_booking_bo = booking_bo.

  ENDMETHOD.

  METHOD zflt_booking_bo_ft_if~save.

    LOOP AT buffer_bo_list
      ASSIGNING FIELD-SYMBOL(<bo_buffer_instance>).

      <bo_buffer_instance>-booking_bo->save( ).

    ENDLOOP.

  ENDMETHOD.

  METHOD zflt_booking_bo_ft_if~clear_buffer.

    CLEAR buffer_bo_list.

  ENDMETHOD.

ENDCLASS.
