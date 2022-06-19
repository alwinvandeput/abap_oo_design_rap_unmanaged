INTERFACE zflt_booking_bo_ft_if
  PUBLIC .

  METHODS check_booking_exists
    IMPORTING booking_id TYPE zflt_booking_bo_if=>t_booking_data-booking
    RETURNING VALUE(booking_exists_ind) TYPE abap_bool.

  METHODS create_booking_bo
    IMPORTING booking_data             TYPE zflt_booking_bo_if=>t_booking_data
    RETURNING VALUE(return_booking_bo) TYPE REF TO zflt_booking_bo_if.

  METHODS get_booking_bo_by_id
    IMPORTING booking_id               TYPE ztbooking_zzap-booking
              buffer_ind               TYPE abap_bool DEFAULT abap_false
    RETURNING VALUE(return_booking_bo) TYPE REF TO zflt_booking_bo_if.

  METHODS clear_buffer.

  METHODS save.

ENDINTERFACE.
