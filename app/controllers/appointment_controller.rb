class AppointmentController < ApplicationController
  before_action :set_appt, only: [:show, :destroy, :update]
  before_action :set_appts, only: [:index]

  def show
    if @appointment[:errors].nil?
      render json: @appointment, status: 200
    else
      render json: @appointment, status: 404
    end
  end

  def index
    if @appointments[:errors].nil?
      render json: @appointments, status: 200
    else
      render json: @appointments, status: 404
    end

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

  ################################ NOTE ###########################
  # Update will not use the search function. Similar to delete, I
  # like that forcing the user to GET to search prevents accidental
  # destruction. Forcing the GET and then the PUT functions acts
  # as a form of user confirmation. Also, search feature would
  # interfere with passing params in for the update since Rails
  # prioroitizes query string params over HTTP request body params
  #################################################################

  def update
    if @appointment[:errors].nil?
      p "*" * 50
      p @appointment[:appointment]
      p update_params
      @appointment[:appointment].update(update_params)
      render json: @appointment, status: 200
    else
      render json: @appointment, status: 404
    end
  end

  def destroy
    if @appointment[:errors].nil?
      Appointment.delete(@appointment[:appointment].id)
      @appointment[:message] = "appointment was deleted"
      render json: @appointment, status: 200
    else
      render json: @appointment, status: 404
    end
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
    these_params = params.require(:appointment).permit(
      :first_name, :last_name, :start_time, :end_time, :comments
    )
    clean_user_input_dates(these_params)
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
    some_params[:start_time] = to_dt(some_params[:start_time]) if some_params[:start_time]
    some_params[:end_time] = to_dt(some_params[:end_time]) if some_params[:end_time]
    some_params
  end

end
