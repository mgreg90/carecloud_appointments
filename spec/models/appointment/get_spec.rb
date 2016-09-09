require 'rails_helper'
require 'airborne'

describe "Appointment API GET Request", type: :request do

# ----------------------------- Before all Block -------------------------------
  before :each do
    # create two test appointments
    Appointment.create( first_name: 'test1firstname',
      last_name: 'test1lastname',
      start_time: DateTime.new(2016, 10, 9, 8, 7, 0, 'EST'),
      end_time: DateTime.new(2016, 10, 9, 9, 7, 0, 'EST'),
      comments: "test1comment"
    )
    Appointment.create( first_name: 'test2firstname',
      last_name: 'test2lastname',
      start_time: DateTime.new(2017, 11, 10, 9, 8, 0, 'EST'),
      end_time: DateTime.new(2017, 11, 10, 10, 8, 0, 'EST'),
      comments: "test2comment"
    )
    Appointment.create( first_name: 'test3firstname',
      last_name: 'test3lastname',
      start_time: DateTime.new(2017, 11, 10, 10, 9, 0, 'EST'),
      end_time: DateTime.new(2017, 11, 10, 11, 9, 0, 'EST'),
      comments: "test3comment"
    )
  end
  # --------------------------- End Before all Block ---------------------------


  it "displays a single appointment by id" do
    id = Appointment.last.id
    get "/appointments/#{id}"
    expect_json(appointment: {id: id} )
    expect_json_types( appointment: {
      first_name: :string,
      last_name: :string,
      start_time: :date,
      end_time: :date,
      comments: :string
    })
    expect_status 200
  end

  it "gives an error if appointment does not exist" do
    id = Appointment.last.id + 1
    get "/appointments/#{id}"
    expect_json(errors: {id: "invalid appointment id given"} )
    expect_status 404

  end

  it "displays a list of appointments" do
    get '/appointments/'

    appointments = json_body[:appointments]
    appt_count = Appointment.all.count

    expect_json_types(appointments: :array_of_objects)
    appointments.each do |x|
      expect(x[:id].class).to be(Fixnum)
      expect(x[:first_name].class).to be(String)
      expect(x[:last_name].class).to be(String)
      expect(x[:start_time].class).to be(String)
      expect(x[:end_time].class).to be(String)
      expect(x[:comments].class).to be(String)
    end

    expect(appointments.length).to eq(appt_count)
    expect(appointments.length).to be > 0
    expect_status 200

  end

  it "gives an error if no appointments exist" do
    Appointment.destroy_all
    get "/appointments/"
    expect_json(errors: {base: "currently no appointments"} )
    expect_status 404

  end

  it "displays a list of appointments by first_name" do
    get "/appointments?first_name=Test1FirstName"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(1)
    expect(appointments.first[:first_name]).to eq('test1firstname')
  end

  it "displays a list of appointments by last_name" do
    get "/appointments?last_name=Test1LastName"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(1)
    expect(appointments.first[:last_name]).to eq('test1lastname')
  end

  it "displays a list of appointments by first_name and last_name" do
    get "/appointments?first_name=Test1FirstName&last_name=Test1LastName"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(1)
    expect(appointments.first[:last_name]).to eq('test1lastname')
  end

  it "displays a list of appointments by start_time" do
    get "/appointments?start_time=10/9/16 9:08"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(2)
    appointments.each do |appt|
      expect(appt[:start_time].to_datetime).to be_in([
        DateTime.new(2017, 11, 10, 9, 8, 0, 'EST'),
        DateTime.new(2017, 11, 10, 10, 9, 0, 'EST')
      ])
    end
  end

  it "displays a list of appointments by end_time" do
    get "/appointments?end_time=10/9/16 8:07"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(1)
    expect(appointments.first[:end_time].to_datetime).to eq(DateTime.new(2016, 10, 9, 9, 7, 0, 'EST'))
  end

  it "displays a list of appointments between start_time and end_time" do
    get "/appointments?start_time=1/1/17 0:0&end_time=11/10/17 10:00"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(1)
    expect(appointments.first[:end_time].to_datetime).to eq(DateTime.new(2017, 11, 10, 10, 8, 0, 'EST'))
  end

  it "displays a list of appointments by year" do
    get "/appointments?year=2017"
    appointments = json_body[:appointments]
    expect(appointments.length).to eq(2)
    appointments.each do |appt|
      expect(appt[:start_time].to_datetime).to be_in([
        DateTime.new(2017, 11, 10, 9, 8, 0, 'EST'),
        DateTime.new(2017, 11, 10, 10, 9, 0, 'EST')
      ])
    end
  end
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


  # Clear appointments after test is done
  after :all do
    Appointment.destroy_all
  end

end
