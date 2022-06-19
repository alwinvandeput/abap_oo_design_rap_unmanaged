CLASS lcl_handler DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR booking RESULT result.

    METHODS modify FOR BEHAVIOR
      IMPORTING
        roots_to_create FOR CREATE booking
        roots_to_update FOR UPDATE booking
        roots_to_delete FOR DELETE booking.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE booking.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE booking.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE booking.

    METHODS read FOR BEHAVIOR
      IMPORTING it_booking_key FOR READ booking RESULT et_booking.

    METHODS lock FOR BEHAVIOR
      IMPORTING it_booking_key FOR LOCK booking.

    METHODS _flag_to_bool
      IMPORTING flag        TYPE if_abap_behv=>t_xflag
      RETURNING VALUE(bool) TYPE abap_bool.

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD modify.

    "------------------------------------------------
    "Create
    LOOP AT roots_to_create INTO DATA(ls_create).

      DATA(create_booking_bo) = zflt_booking_bo_ft=>get_factory(
         )->create_booking_bo(
           booking_data = CORRESPONDING #( ls_create-%data ) ).

      IF ls_create-%cid IS NOT INITIAL.
        INSERT VALUE #( %cid = ls_create-%cid  booking = ls_create-booking )
          INTO TABLE mapped-booking.
      ENDIF.

    ENDLOOP.

    "------------------------------------------------
    "Update
    LOOP AT roots_to_update INTO DATA(ls_update).

      IF ls_update-booking IS INITIAL.
        ls_update-booking = mapped-booking[ %cid = ls_update-%cid_ref ]-booking.
      ENDIF.

      DATA(booking_bo) = zflt_booking_bo_ft=>get_factory(
        )->get_booking_bo_by_id(
          booking_id  = ls_update-booking
          buffer_ind  = abap_true
          "control_id  = ls_delete-%cid_ref
          ).

      booking_bo->update_data(
        booking_data  = CORRESPONDING #( ls_update-%data )
        field_flags  = VALUE #(
            customername       = _flag_to_bool( ls_update-%control-customername )
            numberofpassengers = _flag_to_bool( ls_update-%control-numberofpassengers )
            emailaddress       = _flag_to_bool( ls_update-%control-emailaddress )
            country            = _flag_to_bool( ls_update-%control-country )
            dateofbooking      = _flag_to_bool( ls_update-%control-dateofbooking )
            dateoftravel       = _flag_to_bool( ls_update-%control-dateoftravel )
            cost               = _flag_to_bool( ls_update-%control-cost )
            currencycode       = _flag_to_bool( ls_update-%control-currencycode )
        )
      ).

    ENDLOOP.

    "------------------------------------------------
    "Delete
    LOOP AT roots_to_delete INTO DATA(ls_delete).

      IF ls_delete-booking IS INITIAL.
        ls_delete-booking = mapped-booking[ %cid = ls_delete-%cid_ref ]-booking.
      ENDIF.

      DATA(delete_booking_bo) = zflt_booking_bo_ft=>get_factory(
        )->get_booking_bo_by_id(
          booking_id  = ls_delete-booking
          buffer_ind  = abap_true
          "control_id  = ls_delete-%cid_ref
        ).

      delete_booking_bo->delete( ).

    ENDLOOP.

  ENDMETHOD.

  METHOD _flag_to_bool.

    CASE flag.
      WHEN if_abap_behv=>mk-on.
        bool = abap_true.
      WHEN if_abap_behv=>mk-off.
        bool = abap_false.
      WHEN OTHERS.
        ASSERT 1 = 0.
    ENDCASE.

  ENDMETHOD.

  METHOD read.

    "------------------------------------------------
    "Read
    LOOP AT it_booking_key INTO DATA(ls_booking_key).

      DATA(booking_bo) = zflt_booking_bo_ft=>get_factory(
        )->get_booking_bo_by_id(
          booking_id  = ls_booking_key-Booking
          buffer_ind  = abap_true ).

      DATA(booking_data) = booking_bo->get_data( ).

      INSERT CORRESPONDING #( booking_data ) INTO TABLE et_booking.

    ENDLOOP.

  ENDMETHOD.

  METHOD lock.
    "provide the appropriate lock handling if required
  ENDMETHOD.

ENDCLASS.

CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_saver IMPLEMENTATION.

  METHOD save.

    zflt_booking_bo_ft=>get_factory( )->save( ).

  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

ENDCLASS.
