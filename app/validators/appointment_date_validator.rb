class AppointmentDateValidator < ActiveModel::Validator

  def validate(appt)
    start_time_in_future(appt)

  end

  def start_time_in_future(appt)
    if appt[:start_time] < DateTime.now
      appt.errors.add(:start_time, "start time must be in the future")
    end
  end

end
