require 'rails_helper'
require 'airborne'

describe "Appointment API DELETE Request", type: :request do

  # ----------------------------- Before all Block -------------------------------
  before :each do
    # create two test appointments
    Appointment.create( first_name: 'Test1FirstName',
    last_name: 'Test1LastName',
    start_time: DateTime.new(2016, 10, 9, 8, 7),
    end_time: DateTime.new(2016, 10, 9, 9, 7),
    comments: "Test1Comment"
    )
    Appointment.create( first_name: 'Test2FirstName',
    last_name: 'Test2LastName',
    start_time: DateTime.new(2017, 11, 10, 9, 8),
    end_time: DateTime.new(2017, 11, 10, 10, 8),
    comments: "Test2Comment"
    )
  end
  # --------------------------- End Before all Block ---------------------------
  it "deletes an appointment found by id" do

    id = Appointment.last.id
    delete "/appointments/#{id}"

    expect_status 200

    get "/appointments/#{id}"

    expect_status 404

  end
  it "deletes an appointment found by date"
  it "deletes an appointment found between dates"
  it "deletes an appointment found by year"
  it "deletes an appointment found by month"
  it "deletes an appointment found by day"
  it "deletes an appointment found by hour"
  it "deletes an appointment found by first_name"
  it "deletes an appointment found by last_name"
  it "deletes an appointment found by first_name and date"
  it "deletes an appointment found by last_name and date"
  it "deletes an appointment found by first_name and year"
  it "deletes an appointment found by first_name and month"
  it "deletes an appointment found by first_name and day"
  it "deletes an appointment found by first_name and hour"
  it "deletes an appointment found by last_name and year"
  it "deletes an appointment found by last_name and month"
  it "deletes an appointment found by last_name and day"
  it "deletes an appointment found by last_name and hour"
  it "gives an error if search returns multiple"
  it "gives an error if search returns none"
end
