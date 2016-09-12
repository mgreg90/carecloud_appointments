class AppointmentUpdateValidator < AppointmentDateValidator

  def validate(appt)
    if dates_exist(appt)
      end_time_after_start_time(appt)
      no_appt_conflict(appt)
    end
  end
end
