class Appointment < ApplicationRecord

  def self.set_one(srch_params)
    @appointment = { appointment: find(srch_params[:id]) }
  end

  def self.set_many(srch_params)
    @appointments = { appointments: all }
  end

end
