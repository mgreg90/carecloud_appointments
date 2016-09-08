class AppointmentDateValidator < ActiveModel::Validator

  def validate(appt)
    if dates_exist(appt)
      start_time_in_future(appt)
      end_time_after_start_time(appt)
      no_appt_conflict(appt)
    end
  end

  def dates_exist(appt)
    if appt[:start_time] && appt[:end_time]
      return true
    else
      appt.errors.add(:base, "one of the dates is missing!")
      return false
    end
  end

  def start_time_in_future(appt)
    if appt[:start_time] < DateTime.now
      appt.errors.add(:start_time, "start time must be in the future")
    end
  end

  def end_time_after_start_time(appt)
    if appt[:end_time] <= appt[:start_time]
      appt.errors.add(:end_time, "end time is before start time")
    end
  end

  def no_appt_conflict(appt)
    rng = appt[:start_time]..appt[:end_time]
    conflicts = Appointment.where(start_time: rng)
      .or(Appointment.where(end_time: rng))
    if !conflicts.empty?
      appt.errors.add(:start_time, "appointment time is not in the future")
    end
  end

end
