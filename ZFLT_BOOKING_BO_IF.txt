INTERFACE zflt_booking_bo_if
  PUBLIC.

  TYPES t_key TYPE ztbooking_zzap-booking.

  TYPES t_booking_data TYPE zflt_booking_bo=>t_data.

  TYPES t_field_flags TYPE zflt_booking_dao_if=>t_change_field_flags.

  METHODS get_booking_id
    RETURNING VALUE(booking_id) TYPE t_booking_data-booking.

  METHODS get_data
    RETURNING VALUE(booking_data) TYPE t_booking_data.

  METHODS update_data
    IMPORTING booking_data TYPE t_booking_data
              field_flags  TYPE t_field_flags.

  METHODS delete.

  METHODS save.

ENDINTERFACE.
