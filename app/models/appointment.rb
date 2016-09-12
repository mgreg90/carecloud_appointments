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
      search_hash = Hash.new

      # add first_name and last_name to search hash if available
      names = [:first_name, :last_name]
      search_hash = add_if_avail(search_hash, srch_params, names)

      # add start_time and/or end_time to search hash if available
      full_times = [:start_time, :end_time]
      search_hash = add_if_avail(search_hash, srch_params, full_times)

      unit_times = [:year, :month, :day, :hour]

      # if no start_time or end_time, build a range to search by from time units
      if !exists_in?(search_hash, [:start_time, :end_time]) && unit_times.any? { |ut| srch_params.keys.include?(ut.to_s) }
        search_hash = unit_times_to_dt_ranges(search_hash, unit_times, srch_params, full_times)
      end

      name_hash = search_hash.slice(*names)
      time_range = set_time_range(search_hash)
      search_hash1, search_hash2 = *set_search_hashes(name_hash, time_range)
      p "*" * 50
      p search_hash1, search_hash2
      @appointments = search_x_or_y(search_hash1, search_hash2)
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

  def self.set_search_hashes(name_hash, time_range)
    search_hash1 = name_hash.dup
    search_hash2 = name_hash.dup
    search_hash1[:start_time] = time_range
    search_hash2[:end_time] = time_range
    return [search_hash1, search_hash2]
  end

  def self.set_time_range(search_hash)
    (search_hash[:start_time] || DateTime.new)..(search_hash[:end_time] || Appointment.maximum(:end_time))
  end

  def self.search_x_or_y(search_hash1, search_hash2)
    {
      appointments: Appointment.where(search_hash1)
      .or(Appointment.where(search_hash2))
    }
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
    dt
  end

  # Set Many Helper Methods

  def self.add_if_avail(hash, params, array_of_symbols)
    array_of_symbols.each do |sym|
      hash[sym] = params[sym] if params[sym]
    end
    hash
  end

  def self.exists_in?(hash, array_of_keys)
    array_of_keys.each do |key|
      return false if hash[key].nil?
    end
    true
  end

  def self.unit_times_to_dt_ranges(search_hash, unit_times, srch_params, full_times)
    dt_hash = {start_time: {}, end_time: {}}

    # find most specific time unit
    most_specific_index = find_most_specific_index(unit_times, srch_params)
    # loop thru time_units
    unit_times.each_with_index do |time, index|
      # if time unit is broader than most_specific
      if index > most_specific_index
        # add today's time to both start and end as is
        dt_hash = add_times(dt_hash, time, srch_params, false)
      # elsif time unit is most specific
      elsif index == most_specific_index
        # add it to start and add (it + 1) to end
        dt_hash = add_times(dt_hash, time, srch_params, true)
      # else
      else
        # don't add it
        dt_hash = set_default_time(dt_hash, time)
      # end
      end
    end
    # loop end
    search_hash = build_datetimes_into_search_hash(search_hash, full_times, dt_hash)
    # subtract one second to get end of previous day instead of beginning of current day
    search_hash[:end_time] = search_hash[:end_time] - 1.seconds if search_hash[:end_time]
    p search_hash
    search_hash
  end

  def self.set_default_time(dt_hash, time)
    case time
    when :hour, :year
      dt_hash[:start_time][time] = 0
      dt_hash[:end_time][time] = 0
    when :day, :month
      dt_hash[:start_time][time] = 1
      dt_hash[:end_time][time] = 1
    end
    dt_hash
  end

  def self.find_most_specific_index(unit_times, srch_params)
    most_specific_index = unit_times.count - 1 # declare for scope
    unit_times.each_with_index do |time, index|
      most_specific_index = index if srch_params[time]
    end
    most_specific_index
  end

  def self.add_times(dt_hash, time, srch_params, given)
    [:start_time, :end_time].each do |x|
      if given
        dt_hash[x][time] = srch_params[time].to_i if x == :start_time
        dt_hash[x][time] = srch_params[time].to_i + 1 if x == :end_time
      else
        dt_hash[x][time] = DateTime.now.send(time)
      end
    end
    dt_hash
  end

  def self.build_datetimes_into_search_hash(search_hash, full_times, dt_hash)
    full_times.each do |time|
      search_hash[time] = DateTime.new(
        dt_hash[time][:year],
        dt_hash[time][:month],
        dt_hash[time][:day],
        dt_hash[time][:hour],
        0, 0, 'EST'
      )
    end
    search_hash
  end

end
