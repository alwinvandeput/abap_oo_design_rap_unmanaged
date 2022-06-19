INTERFACE zflt_booking_dao_ft_if
  PUBLIC .

  TYPES t_booking_data TYPE zflt_booking_dao_if=>t_booking_data.

  METHODS check_exists
    IMPORTING booking_id        TYPE t_booking_data-booking
    RETURNING VALUE(exists_ind) TYPE abap_bool.

  METHODS get_last_booking_id
    RETURNING VALUE(booking_id) TYPE t_booking_data-booking.

  METHODS create_dao
    IMPORTING booking_data       TYPE t_booking_data
    RETURNING VALUE(booking_dao) TYPE REF TO zflt_booking_dao_if.

  METHODS get_dao
    IMPORTING booking_id         TYPE t_booking_data-booking
    RETURNING VALUE(booking_dao) TYPE REF TO zflt_booking_dao_if.

ENDINTERFACE.
