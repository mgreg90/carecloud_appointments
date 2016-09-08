class Appointment < ApplicationRecord

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :start_time, presence: { message: "blank or invalid date" }
  validates :end_time, presence: { message: "blank or invalid date" }

  validates_with AppointmentDateValidator

  def self.set_one(srch_params)
    @appointment = { appointment: find_by_id(srch_params[:id]) }
    if @appointment[:appointment].nil?
      @appointment = {
        errors: {
          id: "invalid appointment id given"
        }
      }
    end
    @appointment
  end

  def self.set_many(srch_params)
    @appointments = { appointments: all }
    if @appointments[:appointments].empty?
      @appointments = {
        errors: {
          base: "currently no appointments"
        }
      }
    end
    @appointments
  end

end
