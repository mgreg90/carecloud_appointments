require 'rails_helper'
require 'airborne'

describe "Appointment API POST Request", type: :request do

  # ----------------------------- Before all Block -------------------------------
  before :each do
    @first_name = "Test1FirstName"
    @last_name = "Test1LastName"
    @start_time = "10/9/2011 8:07"
    @end_time = "10/9/2011 9:07"
    @comments = "Test1Comment"
  end
  # --------------------------- End Before all Block ---------------------------


  it "creates a new appointment" do
    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    p url

    post "#{url}"

    appt = Appointment.last
    expect(appt.first_name).to eq('Test1FirstName')
    expect(appt.last_name).to eq('Test1LastName')
    expect(appt.start_time).to eq(DateTime.new(2011, 10, 9, 8, 7, 0, 'EST'))
    expect(appt.end_time).to eq(DateTime.new(2011, 10, 9, 9, 7, 0, 'EST'))
    expect(appt.comments).to eq('Test1Comment')
  end

  it "creates a new appointment with given timezones" do

    @start_time << ' CST'
    @end_time << ' CST'

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    p url

    post "#{url}"

    appt = Appointment.last
    expect(appt.first_name).to eq('Test1FirstName')
    expect(appt.last_name).to eq('Test1LastName')
    expect(appt.start_time).to eq(DateTime.new(2011, 10, 9, 8, 7, 0, 'CST'))
    expect(appt.end_time).to eq(DateTime.new(2011, 10, 9, 9, 7, 0, 'CST'))
    expect(appt.comments).to eq('Test1Comment')
  end

  it "doesn't create a new appointment if there is no first_name"
  it "doesn't create a new appointment if there is no last_name"
  it "doesn't create a new appointment if there is no start_time"
  it "doesn't create a new appointment if there is no end_time"

  # Clear appointments after test is done
  after :all do
    Appointment.destroy_all
  end

end
