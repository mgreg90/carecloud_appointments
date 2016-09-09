require 'rails_helper'
require 'airborne'

describe "Appointment API GET Request", type: :request do

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


  # Clear appointments after test is done
  after :all do
    Appointment.destroy_all
  end

end
