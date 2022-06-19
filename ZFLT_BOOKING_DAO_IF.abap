INTERFACE zflt_booking_dao_if
  PUBLIC .

    TYPES t_booking_data TYPE ztbooking_zzap.

    TYPES:
      t_update_flag TYPE abap_bool,

      BEGIN OF t_change_field_flags,
        customername       TYPE t_update_flag,
        numberofpassengers TYPE t_update_flag,
        emailaddress       TYPE t_update_flag,
        country            TYPE t_update_flag,
        dateofbooking      TYPE t_update_flag,
        dateoftravel       TYPE t_update_flag,
        cost               TYPE t_update_flag,
        currencycode       TYPE t_update_flag,
      END OF t_change_field_flags.

    TYPES BEGIN OF t_field_flags.
    INCLUDE TYPE t_change_field_flags.
    TYPES lastchangedat      TYPE t_update_flag.
    TYPES END OF t_field_flags.

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
