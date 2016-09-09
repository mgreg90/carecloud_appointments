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
      names = [:first_name, :last_name]
      full_times = [:start_time, :end_time]
      unit_times = [:hour, :day, :month, :year]
      search_hash = Hash.new
      dt_hash = Hash.new

      # add first_name and last_name to search hash if available
      names.each do |name|
        search_hash[name] = srch_params[name] if srch_params[name]
      end

      # add start_time and/or end_time to search hash if available
      full_times.each do |time|
        search_hash[time] = srch_params[time] if srch_params[time]
      end

      # if no start_time or end_time, build a range to search by from time units
      if search_hash[:start_time].nil? && search_hash[:end_time].nil? && unit_times.any? { |sh| srch_params.keys.include?(sh) }
        most_specific_index = unit_times.count - 1 # declare for scope
        # find most specific time unit
        unit_times.each_with_index do |time, index|
          most_specific_index = index if srch_params[time]
        end
        # loop thru time_units
        unit_times.each_with_index do |time, index|
          # if time unit is broader than most_specific
          if index > most_specific_index
            # add it to both start and end as is
            dt_hash[:start_time][time] = srch_params[time]
            dt_hash[:end_time][time] = srch_params[time]
          # elsif time unit is most specific
          elsif index == most_specific_index
            # add it to start and add (it + 1) to end
            dt_hash[:start_time][time] = srch_params[time]
            dt_hash[:end_time][time] = srch_params[time] + 1.send("#{time}s")
          # else
          else
            # don't add it
            dt_hash[:start_time][time] = 0
            dt_hash[:end_time][time] = 0
          # end
          end
        end
        # loop end
        # build datetimes into search hash
        full_times.each do |time|
          search_hash[time] = DateTime.new(
            dt_hash[time][:year],
            dt_hash[time][:month],
            dt_hash[time][:day],
            dt_hash[time][:hour]
          )
        end
      end
      name_hash = search_hash.slice(:first_name, :last_name)
      time_range = (search_hash[:start_time] || DateTime.new)..(search_hash[:end_time] || Appointment.maximum(:end_time))
      search_hash1 = name_hash.dup
      search_hash2 = name_hash.dup
      search_hash1[:start_time] = time_range
      search_hash2[:end_time] = time_range
      p "----------------------------- TESTING - FINAL ------------------------"
      p "dt_hash:"
      p dt_hash
      p "time_range:"
      p time_range
      p "search_hash1:"
      p search_hash1
      p "search_hash2"
      p search_hash2
      p "appointments:"
      @appointments = {
        appointments: Appointment.where(search_hash1)
        .or(Appointment.where(search_hash2))
      }
      p @appointments
    end
    if @appointments[:appointments].nil? || @appointments[:appointments].empty?
      @appointments = {
        errors: {
          base: "currently no appointments"
        }
      }
    end
    @appointments
  end

  def self.to_dt(date_time_string)
    # Converts date from string in format (m/d/yyyy hh:mm) to DateTime (only EST)
    if date_time_string.last.to_i.to_s != date_time_string.last
      # if the last char of dt_string is a letter,
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
      # otherwise assume eastern standard time, because CC is in Boston & Miami
      dt = DateTime.strptime("#{date_time_string} EST", '%m/%d/%Y %H:%M %Z')
    end
    dt = (dt + 2000.years) if (dt.year < 1900)
    # p "dt:"
    # p dt.year
    dt
  end

end
