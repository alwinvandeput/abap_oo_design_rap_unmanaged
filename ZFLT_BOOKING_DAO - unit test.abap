CLASS unit_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  CREATE PROTECTED.

  PRIVATE SECTION.

    METHODS test_1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS zflt_booking_dao DEFINITION LOCAL FRIENDS unit_test.

CLASS unit_test IMPLEMENTATION.

  METHOD test_1.

    GET TIME STAMP FIELD DATA(current_time_stamp).

    CONVERT TIME STAMP current_time_stamp
      TIME ZONE 'UTC'
      INTO DATE DATA(current_date) TIME DATA(current_time).

    DATA(booking_id) = zflt_booking_dao_ft=>get_factory( )->get_last_booking_id( ) + 1.

    DATA(exp_booking_data) =
      VALUE zflt_booking_dao_if=>t_booking_data(
        booking            = booking_id
        customername       = CONV #( |Customer: { current_date }{ current_time }| )
        numberofpassengers = 2
        emailaddress       = |test@test.nl|
        country            = 'NL'
        dateofbooking      = current_time_stamp
        dateoftravel       = current_time_stamp
        cost               = '523.29'
*        currencycode       : abap.cuky;
*        lastchangedat      : timestampl;
      ).

    "--------------------------------------------------
    "Check existence
    "--------------------------------------------------
    DATA(booking_exists_ind) =
      zflt_booking_dao_ft=>get_factory(
        )->check_exists( exp_booking_data-booking ).

    cl_Abap_Unit_Assert=>assert_equals(
      exp = abap_false
      act = booking_exists_ind ).

    "--------------------------------------------------
    "Create booking
    "--------------------------------------------------
    DATA(booking_dao) =
      zflt_booking_dao_ft=>get_factory(
        )->create_dao( exp_booking_data ).

    booking_dao->save( ).

    COMMIT WORK.

    "Check result and read test
    booking_dao =
      zflt_booking_dao_ft=>get_factory(
        )->get_dao( exp_booking_data-booking ).

    DATA(act_booking_data) = booking_dao->get_data( ).

    exp_booking_data-client = sy-mandt.

    cl_Abap_Unit_Assert=>assert_equals(
      exp = exp_booking_data
      act = act_booking_data ).

    "--------------------------------------------------
    "Update booking
    "--------------------------------------------------
    exp_booking_data-emailaddress = |test2@test2.nl|.

    booking_dao->update_data(
      booking_data = VALUE #(
        emailaddress = exp_booking_data-emailaddress )
      field_flags = VALUE #(
         emailaddress = abap_true ) ).

    booking_dao->save( ).

    COMMIT WORK.

    "Check result and read test
    booking_dao =
      zflt_booking_dao_ft=>get_factory(
        )->get_dao( exp_booking_data-booking ).

    act_booking_data = booking_dao->get_data( ).

    cl_Abap_Unit_Assert=>assert_equals(
      exp = exp_booking_data
      act = act_booking_data ).

    "--------------------------------------------------
    "Check exists
    booking_exists_ind =
      zflt_booking_dao_ft=>get_factory(
        )->check_exists(
        exp_booking_data-booking ).

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = booking_exists_ind ).

    "--------------------------------------------------
    "Delete
    "--------------------------------------------------
    RETURN.

    booking_dao =
      zflt_booking_dao_ft=>get_factory(
        )->get_dao( exp_booking_data-booking ).

    booking_dao->delete( ).

    booking_dao->save( ).

    COMMIT WORK.

    "--------------------------------------------------
    "Check exists
    booking_exists_ind =
      zflt_booking_dao_ft=>get_factory(
        )->check_exists(
        exp_booking_data-booking ).

    cl_abap_unit_assert=>assert_equals(
      exp = abap_false
      act = booking_exists_ind ).

  ENDMETHOD.

ENDCLASS.
