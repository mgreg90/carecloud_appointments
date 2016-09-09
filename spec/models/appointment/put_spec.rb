require 'rails_helper'
require 'airborne'

describe "Appointment API PUT Request", type: :request do

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

  it "updates an appointment's name found by id" do

    id = Appointment.last.id
    put "/appointments/#{id}",
      params: {
        appointment: {
          last_name: "Test3LastName",
          first_name: "Test3FirstName"
        }
      }

    expect(Appointment.last.last_name).to eq("Test3LastName")
    expect(Appointment.last.first_name).to eq("Test3FirstName")

  end
  # it "updates an appointment found by date"
  # it "updates an appointment found between dates"
  # it "updates an appointment found by year"
  # it "updates an appointment found by month"
  # it "updates an appointment found by day"
  # it "updates an appointment found by hour"
  # it "updates an appointment found by first_name"
  # it "updates an appointment found by last_name"
  # it "updates an appointment found by first_name and date"
  # it "updates an appointment found by last_name and date"
  # it "updates an appointment found by first_name and year"
  # it "updates an appointment found by first_name and month"
  # it "updates an appointment found by first_name and day"
  # it "updates an appointment found by first_name and hour"
  # it "updates an appointment found by last_name and year"
  # it "updates an appointment found by last_name and month"
  # it "updates an appointment found by last_name and day"
  # it "updates an appointment found by last_name and hour"
  # it "gives an error if search returns multiple"
  # it "gives an error if search returns none"
end
