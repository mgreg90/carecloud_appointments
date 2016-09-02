require 'rails_helper'
require 'airborne'

describe "Appointment API GET Request", type: :request do
  Appointment.create( first_name: 'Test1FirstName',
                      last_name: 'Test1LastName',
                      start_time: DateTime.new(2011, 10, 9, 8, 7),
                      end_time: DateTime.new(2011, 10, 9, 9, 7))
  Appointment.create( first_name: 'Test2FirstName',
                      last_name: 'Test2LastName',
                      start_time: DateTime.new(2012, 11, 10, 9, 8),
                      end_time: DateTime.new(2012, 11, 10, 10, 8))

  it "displays a single appointment by id" do
    get '/appointments/1',
      params: { id: 1 }

    expect_json
  end
  it "displays a list of appointments"
  it "displays a list of appointments by date"
  it "displays a list of appointments between dates"
  it "displays a list of appointments by year"
  it "displays a list of appointments by month"
  it "displays a list of appointments by day"
  it "displays a list of appointments by hour"
  it "displays a list of appointments by first_name"
  it "displays a list of appointments by last_name"
  it "displays a list of appointments by first_name and date"
  it "displays a list of appointments by last_name and date"
  it "displays a list of appointments by first_name and year"
  it "displays a list of appointments by first_name and month"
  it "displays a list of appointments by first_name and day"
  it "displays a list of appointments by first_name and hour"
  it "displays a list of appointments by last_name and year"
  it "displays a list of appointments by last_name and month"
  it "displays a list of appointments by last_name and day"
  it "displays a list of appointments by last_name and hour"
end
