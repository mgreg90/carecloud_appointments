class AppointmentDateValidator < ActiveModel::Validator

  def validate(appt)
    if dates_exist(appt)
      start_time_in_future(appt)
      end_time_after_start_time(appt)
      no_appt_conflict(appt)
      no_appt_overlap(appt)
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
    unless conflicts.empty? || (conflicts.count == 1 && appt.id == conflicts.first.id)
      # if there are no conflicts or one conflict is the active appt (for update)
      # then it is valid
      appt.errors.add(:start_time, "time conflicts with another appointment")
    end
  end

  def no_appt_overlap(appt)
    overlaps = Appointment.where('start_time < ?', appt[:start_time])
      .where('end_time > ?', appt[:end_time])
    unless overlaps.empty? || (overlaps.count == 1 && appt.id == overlaps.first.id)
      appt.errors.add(:start_time, "time conflicts with another appointment")
    end
  end
end

# localhost:3000/appointments?first_name=Test&last_name=Test&start_time=11/1/13 6:30&end_time=11/1/13 7:10
