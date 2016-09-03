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

  def update_params
    params
  end

end
