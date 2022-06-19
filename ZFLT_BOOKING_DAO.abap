CLASS zflt_booking_dao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zflt_booking_dao_ft.

  PUBLIC SECTION.

    INTERFACES zflt_booking_dao_if.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES t_status TYPE string.

    CONSTANTS:
      BEGIN OF gcs_status,
        new        TYPE t_status VALUE 'NEW',
        not_read   TYPE t_status VALUE 'NOT_READ',
        read       TYPE t_status VALUE 'READ',
        update     TYPE t_status VALUE 'UPDATE',
        delete     TYPE t_status VALUE 'DELETE',
        new_delete TYPE t_status VALUE 'NEW_DELETE',
      END OF gcs_status.

    DATA booking_data TYPE zflt_booking_dao_if=>t_booking_data.

    DATA status TYPE t_status.

ENDCLASS.

CLASS zflt_booking_dao IMPLEMENTATION.

  METHOD zflt_booking_dao_if~get_booking_id.

    booking_id = booking_data-booking.

  ENDMETHOD.

  METHOD zflt_booking_dao_if~delete.

    IF me->status = gcs_status-new OR
       me->status = gcs_status-new_delete.

      me->status = gcs_status-delete.

    ELSE.

      me->status = gcs_status-delete.

    ENDIF.

  ENDMETHOD.

  METHOD zflt_booking_dao_if~get_data.

    IF me->status = gcs_status-not_read.

      SELECT SINGLE *
        FROM ztbooking_zzap
        WHERE
          booking = @me->booking_data-booking
        INTO @me->booking_data.

      ASSERT sy-subrc = 0.

    ENDIF.

    booking_data = me->booking_data.

  ENDMETHOD.

  METHOD zflt_booking_dao_if~update_data.

    "Read all data
    me->zflt_booking_dao_if~get_data( ).

    CASE me->status.

      WHEN gcs_status-delete OR
           gcs_status-new_delete.

        RETURN.

      WHEN gcs_status-new.

      WHEN gcs_status-not_read OR
           gcs_status-read.

        me->status = gcs_status-update.

      WHEN OTHERS.
        ASSERT 1 = 0.

    ENDCASE.

    "--------------------------------------------
    "Map fields
    DATA(struct_descr) =
      CAST cl_abap_structdescr(
        cl_abap_structdescr=>describe_by_data( me->booking_data ) ).

    DATA(components) = struct_descr->get_components( ).

    LOOP AT components
      ASSIGNING FIELD-SYMBOL(<component>).

      ASSIGN COMPONENT <component>-name
        OF STRUCTURE field_flags
        TO FIELD-SYMBOL(<control_field>).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <control_field> IS INITIAL.
        CONTINUE.
      ENDIF.

      ASSIGN COMPONENT <component>-name
        OF STRUCTURE booking_data
        TO FIELD-SYMBOL(<source_field>).

      ASSIGN COMPONENT <component>-name
        OF STRUCTURE me->booking_data
        TO FIELD-SYMBOL(<target_field>).

      <target_field> = <source_field>.

    ENDLOOP.

  ENDMETHOD.

  METHOD zflt_booking_dao_if~save.

    CASE me->status.

      WHEN gcs_status-delete.

        DELETE FROM ztbooking_zzap
          WHERE booking = @me->booking_data-booking.

        ASSERT sy-subrc = 0.

      WHEN gcs_status-new_delete.

        RETURN.

      WHEN gcs_status-new.

        INSERT ztbooking_zzap
          FROM @me->booking_data.

        ASSERT sy-subrc = 0.

      WHEN gcs_status-not_read OR
           gcs_status-read.

        RETURN.

      WHEN gcs_status-update.

        UPDATE ztbooking_zzap
          FROM @me->booking_data.

        ASSERT sy-subrc = 0.

        CLEAR me->booking_data.

        me->status = gcs_status-not_read.

      WHEN OTHERS.

        ASSERT 1 = 0.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
