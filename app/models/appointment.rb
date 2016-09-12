class Appointment < ApplicationRecord

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :start_time, presence: { message: "blank or invalid date" }
  validates :end_time, presence: { message: "blank or invalid date" }

  validates_with AppointmentDateValidator, on: [:create]
  validates_with AppointmentUpdateValidator, on: [:update]

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
      search_hash = Hash.new

      # add first_name and last_name to search hash if available
      names = [:first_name, :last_name]
      search_hash = add_if_avail(search_hash, srch_params, names)

      # add start_time and/or end_time to search hash if available
      full_times = [:start_time, :end_time]
      search_hash = add_if_avail(search_hash, srch_params, full_times)

      name_hash = search_hash.slice(*names)
      time_range = set_time_range(search_hash)
      search_hash1, search_hash2 = *set_search_hashes(name_hash, time_range)
      @appointments = search_x_or_y(search_hash1, search_hash2)
    end
    if @appointments[:appointments].nil? || @appointments[:appointments].empty?
      @appointments = {
        errors: {
          base: "no appointments found"
        }
      }
    end
    @appointments
  end

  def self.set_search_hashes(name_hash, time_range)
    search_hash1 = name_hash.dup
    search_hash2 = name_hash.dup
    search_hash1[:start_time] = time_range
    search_hash2[:end_time] = time_range
    return [search_hash1, search_hash2]
  end

  def self.set_time_range(search_hash)
    (search_hash[:start_time] || DateTime.new)..(search_hash[:end_time] || (Appointment.maximum(:end_time).to_datetime))
  end

  def self.search_x_or_y(search_hash1, search_hash2)
    {
      appointments: Appointment.where(search_hash1)
      .or(Appointment.where(search_hash2))
    }
  end

  # Converts date from string in format (m/d/yyyy hh:mm) to DateTime (only EST)
  def self.to_dt(date_time_string, end_of_day = false)
    # if the last char of dt_string is a letter,
    if date_time_string.last.to_i.to_s != date_time_string.last
      # get user provided timezone
      tz = date_time_string.split.last.upcase
      if !DateTime.strptime("#{date_time_string}", '%m/%d/%Y %H:%M %Z')
        .zone.to_i.zero? || tz == 'UTC' || tz == 'GMT'
        # if tz is valid, use it.
        dt = DateTime.strptime("#{date_time_string}", '%m/%d/%Y %H:%M %Z')
      else
        # else return
        return
        # simple return will work because we validate dates for presence
      end
    else
      # if there is not a time given
      begin
        DateTime.strptime("#{date_time_string}", '%m/%d/%Y %H:%M')
      rescue
        if end_of_day
          date_time_string << " 23:59"
        else
          date_time_string << " 00:00"
        end
      end
      # otherwise assume eastern standard time, because CC is in Boston & Miami
      dt = DateTime.strptime("#{date_time_string} EST", '%m/%d/%Y %H:%M %Z')
    end
    # correction for year by two digits, ex. so that 11/10/18 is in 2018 not 0018
    dt = (dt + 2000.years) if (dt.year < 1900)
    dt
  end

  # Set Many Helper Methods

  def self.add_if_avail(hash, params, array_of_symbols)
    array_of_symbols.each do |sym|
      hash[sym] = params[sym] if params[sym]
    end
    hash
  end

end
