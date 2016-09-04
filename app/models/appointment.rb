class Appointment < ApplicationRecord

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :start_time, presence: { message: "blank or invalid date" }
    validates :end_time, presence: { message: "blank or invalid date" }

  def self.set_one(srch_params)
    @appointment = { appointment: find(srch_params[:id]) }
  end

  def self.set_many(srch_params)
    @appointments = { appointments: all }
  end

end
