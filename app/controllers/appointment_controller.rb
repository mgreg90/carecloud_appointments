class AppointmentController < ApplicationController

  def show
    @appointment = Appointment.find(params[:id])
    render json: @appointment, status: 200
  end

  def index

  end

  def create

  end

  def update

  end

  def destroy

  end

  private # -------------------------- private ---------------------------------

  def search_params

  end

  def update_params

  end

end
