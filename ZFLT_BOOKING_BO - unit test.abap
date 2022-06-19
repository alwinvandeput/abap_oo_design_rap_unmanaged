CLASS unit_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS test_1 FOR TESTING
      RAISING cx_static_check.

ENDCLASS.

CLASS unit_test IMPLEMENTATION.

  METHOD test_1.

    "---------------------------------------------------------------
    "Test data
    "---------------------------------------------------------------
    DATA(exp_booking_data) =
      VALUE zflt_booking_bo_if=>t_booking_data(
        customername       = 'Test customer'
        numberofpassengers = 9
        emailaddress       = 'john.johnson@miami.vice'
        country            = 'NL'
        dateofbooking      = '20180213125959.0000000'
        dateoftravel       = '20180214125959.0000000'
        cost               = '200.25'
        currencycode       = 'EUR'
      ).

    "---------------------------------------------------------------
    "Create
    "---------------------------------------------------------------
    DATA(booking_bo) =
      zflt_booking_bo_ft=>get_factory(
        )->create_booking_bo( exp_booking_data ).

    exp_booking_data-booking = booking_bo->get_booking_id( ).

    booking_bo->save( ).

    COMMIT WORK.

    "---------------------------------------------------------------
    "Check
    DATA(booking_bo_ft) = zflt_booking_bo_ft=>get_factory( ).

    booking_bo_ft->clear_buffer( ).

    booking_bo =
      zflt_booking_bo_ft=>get_factory(
        )->get_booking_bo_by_id( exp_booking_data-booking ).

    DATA(act_booking_data) = booking_bo->get_data( ).

    "- Check change date
    cl_abap_unit_assert=>assert_not_initial( act_booking_data-lastchangedat ).

    "- Check other fields
    exp_booking_data-client        = act_booking_data-client.
    exp_booking_data-booking       = act_booking_data-booking.
    exp_booking_data-lastchangedat = act_booking_data-lastchangedat.

    cl_abap_unit_assert=>assert_equals(
      exp = exp_booking_data
      act = act_booking_data ).

    "---------------------------------------------------------------
    "Update
    "---------------------------------------------------------------
    WAIT UP TO 1 SECONDS.

    GET TIME STAMP FIELD DATA(current_time_stamp).

    CONVERT TIME STAMP current_time_stamp
      TIME ZONE 'UTC'
      INTO DATE DATA(current_date) TIME DATA(current_time).

    exp_booking_data-customername =
      |New customer name { current_time TIME = USER } { current_date  DATE = USER }|.

    booking_bo =
      zflt_booking_bo_ft=>get_factory(
        )->get_booking_bo_by_id( exp_booking_data-booking ).

    booking_bo->update_data(
      booking_data = VALUE #(
         customername = exp_booking_data-customername )
      field_flags = VALUE #(
        customername = abap_true ) ).

    booking_bo->save( ).

    COMMIT WORK.

    "---------------------------------------------------------------
    "Check
    booking_bo_ft = zflt_booking_bo_ft=>get_factory( ).

    booking_bo_ft->clear_buffer( ).

    booking_bo =
      zflt_booking_bo_ft=>get_factory(
        )->get_booking_bo_by_id( exp_booking_data-booking ).

    act_booking_data = booking_bo->get_data( ).

    "- Check last change date is changed
    IF act_booking_data-lastchangedat > exp_booking_data-lastchangedat.
      DATA(lastchangedat_changed_ind) = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = lastchangedat_changed_ind ).

    exp_booking_data-lastchangedat = act_booking_data-lastchangedat.

    "- Check customer name is changed
    cl_abap_unit_assert=>assert_equals(
      exp = exp_booking_data
      act = act_booking_data ).

    "---------------------------------------------------------------
    "Delete
    "---------------------------------------------------------------
    RETURN.

    booking_bo->delete( ).

    booking_bo->save( ).

    COMMIT WORK.

    "---------------------------------------------------------------
    "Check
    booking_bo_ft = zflt_booking_bo_ft=>get_factory( ).

    DATA(act_booking_exists) = booking_bo_ft->check_booking_exists( exp_booking_data-booking ).

    cl_abap_unit_assert=>assert_equals(
      exp = abap_false
      act = act_booking_exists ).

  ENDMETHOD.

ENDCLASS.
