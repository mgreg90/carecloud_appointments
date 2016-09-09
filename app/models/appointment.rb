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
    if srch_params.empty?
      @appointments = { appointments: all }
    else
      # if first_name or last_name
        # add to search hash
      # end

      # if start_time or end_time
        # reformat start_time if it exists
        # reformat end_time if it exists
        # add to search hash
        # search by all available of start_time, end_time, first_name, last_name
      # elsif hour or day or month or year
        # if hour
          # add hour to dt_hash
        # end
        # if day
          # add day to dt_hash
        # end
        # if month
          # add month to dt_hash
        # end
        # if year
          # add year to dt_hash
        # end
        # create dt from dt_hash
        # search by all available of date_time, first_name, last_name
      # else
        # search by all available of first_name, last_name
      # end

    end
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
