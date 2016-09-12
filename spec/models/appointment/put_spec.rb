require 'rails_helper'
require 'airborne'

describe "Appointment API PUT Request", type: :request do

  # ----------------------------- Before all Block -------------------------------
    before :each do
      # create two test appointments
      Appointment.create( first_name: 'Test1FirstName',
        last_name: 'Test1LastName',
        start_time: DateTime.new(2018, 10, 9, 8, 7),
        end_time: DateTime.new(2018, 10, 9, 9, 7),
        comments: "Test1Comment"
        )
      Appointment.first.update(
        start_time: DateTime.new(2015, 10, 9, 8, 7),
        end_time: DateTime.new(2018, 10, 9, 9, 7)
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
    put "/appointments/#{id}?last_name=Test3LastName&first_name=Test3FirstName"

    expect(Appointment.last.last_name).to eq("Test3LastName".downcase)
    expect(Appointment.last.first_name).to eq("Test3FirstName".downcase)

  end

  it "updates an appointment's start_time and end_time found by id" do

    id = Appointment.last.id
    put "/appointments/#{id}?start_time=12/25/2018 11:30&end_time=12/25/2018 12:30"

    expect(Appointment.last.start_time).to eq(
      DateTime.new(2018, 12, 25, 11, 30, 0, 'EST')
    )
    expect(Appointment.last.end_time).to eq(
      DateTime.new(2018, 12, 25, 12, 30, 0, 'EST')
    )

  end

  it "updates an appointment's times and names found by id" do

    id = Appointment.last.id
    put "/appointments/#{id}?start_time=12/25/2018 11:30&end_time=12/25/2018 12:30"\
    "&first_name=david&last_name=mercer"

    expect(Appointment.last.start_time).to eq(
      DateTime.new(2018, 12, 25, 11, 30, 0, 'EST')
    )
    expect(Appointment.last.end_time).to eq(
      DateTime.new(2018, 12, 25, 12, 30, 0, 'EST')
    )
    expect(Appointment.last.last_name).to eq("mercer".downcase)
    expect(Appointment.last.first_name).to eq("david".downcase)

  end

  it "updates an appointment's names found by id even if dates in the past" do
    appt = Appointment.find_by(last_name: "Test1LastName")

    id = appt.id
    put "/appointments/#{id}?first_name=david&last_name=mercer"

    expect(Appointment.find(id).last_name).to eq("Test1LastName")
    expect(Appointment.find(id).first_name).to eq("Test1FirstName")

  end


end
