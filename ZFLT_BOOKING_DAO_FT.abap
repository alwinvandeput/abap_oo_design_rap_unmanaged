CLASS zflt_booking_dao_ft DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zflt_booking_dao_ft_if.

    CLASS-METHODS get_factory
      RETURNING VALUE(return_factory) TYPE REF TO zflt_booking_dao_ft_if.

  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA factory TYPE REF TO zflt_booking_dao_ft_if.

ENDCLASS.

CLASS zflt_booking_dao_ft IMPLEMENTATION.

  METHOD get_factory.

    IF factory IS INITIAL.
      factory = NEW zflt_booking_dao_ft( ).
    ENDIF.

    return_factory = factory.

  ENDMETHOD.

  METHOD zflt_booking_dao_ft_if~check_exists.

    SELECT SINGLE @abap_true
      FROM ztbooking_zzap
      WHERE
        booking = @booking_id
      INTO @exists_ind.

  ENDMETHOD.

  METHOD zflt_booking_dao_ft_if~get_last_booking_id.

    SELECT SINGLE MAX( booking )
      FROM ztbooking_zzap
      INTO @booking_id.

  ENDMETHOD.

  METHOD zflt_booking_dao_ft_if~create_dao.

    DATA(temp_booking_dao) = NEW zflt_booking_dao( ).

    temp_booking_dao->booking_data = booking_data.

    temp_booking_dao->status = zflt_booking_dao=>gcs_status-new.

    booking_dao = temp_booking_dao.

  ENDMETHOD.

  METHOD zflt_booking_dao_ft_if~get_dao.

    IF zflt_booking_dao_ft_if~check_exists( booking_id ) = abap_false.
      ASSERT 1 = 0.
    ENDIF.

    DATA(temp_booking_dao) = NEW zflt_booking_dao( ).

    temp_booking_dao->booking_data-booking = booking_id.

    temp_booking_dao->status = zflt_booking_dao=>gcs_status-not_read.

    booking_dao = temp_booking_dao.

  ENDMETHOD.

ENDCLASS.
