class AppointmentController < ApplicationController
  before_action :set_appt, only: [:show]
  before_action :set_appts, only: [:index]

  def show
    render json: @appointment, status: 200
  end

  def index
    render json: @appointments, status: 200
  end

  def create
    @appointment = Appointment.new(new_params)
    # @appointment.massage!
    if @appointment.save
      render json: @appointment, status: 201
    else
      render json: {errors: @appointment.errors}, status: 400
    end
  end

  def update

  end

  def destroy

  end

  private # -------------------------- private ---------------------------------

  def set_appt
    @appointment = Appointment.set_one(search_params)
  end

  def set_appts
    @appointments = Appointment.set_many(search_params)
  end

  def search_params
    params
  end

  def new_params
    these_params = params.permit(
      :first_name, :last_name, :start_time, :end_time, :comments
    )
    clean_user_input_dates(these_params)
  end

  def update_params
    params
  end

  def to_dt(date_time_string)
    # Converts date from string in format (m/d/yyyy hh:mm) to DateTime (only EST)
    if date_time_string.last.to_i.to_s != date_time_string.last
      # if the last char of dt_string is a letter,
      tz = date_time_string.split.last.upcase
      if !DateTime.strptime("#{date_time_string}", '%m/%d/%Y %H:%M %Z')
        .zone.to_i.zero? || tz == 'UTC' || tz == 'GMT'
        # if tz is valid, use it.
        DateTime.strptime("#{date_time_string}", '%m/%d/%Y %H:%M %Z')
      else
        # else return
        return
        # simple return will work because we validate dates for presence
      end
    else
      # otherwise assume eastern standard time, because CC is in Boston & Miami
      DateTime.strptime("#{date_time_string} EST", '%m/%d/%Y %H:%M %Z')
    end
  end

  def clean_user_input_dates(some_params)
    some_params[:start_time] = to_dt(some_params[:start_time])
    some_params[:end_time] = to_dt(some_params[:end_time])
    some_params
  end

end
