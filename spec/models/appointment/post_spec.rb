require 'rails_helper'
require 'airborne'

describe "Appointment API POST Request", type: :request do

  # ----------------------------- Before all Block -------------------------------
  before :each do
    @first_name = "Test1FirstName"
    @last_name = "Test1LastName"
    @start_time = "10/9/2017 8:07"
    @end_time = "10/9/2017 9:07"
    @comments = "Test1Comment"
  end
  # --------------------------- End Before all Block ---------------------------

# --------------------------------------- Successful Creation Tests ------------
  it "creates a new appointment" do
    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    appt = Appointment.last
    expect(appt.first_name).to eq('Test1FirstName'.downcase)
    expect(appt.last_name).to eq('Test1LastName'.downcase)
    expect(appt.start_time).to eq(DateTime.new(2017, 10, 9, 8, 7, 0, 'EST'))
    expect(appt.end_time).to eq(DateTime.new(2017, 10, 9, 9, 7, 0, 'EST'))
    expect(appt.comments).to eq('Test1Comment')

    expect_status 201
  end

  it "creates a new appointment with given timezones" do

    @start_time << ' CST'
    @end_time << ' CST'

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    appt = Appointment.last
    expect(appt.first_name).to eq('Test1FirstName'.downcase)
    expect(appt.last_name).to eq('Test1LastName'.downcase)
    expect(appt.start_time).to eq(DateTime.new(2017, 10, 9, 8, 7, 0, 'CST'))
    expect(appt.end_time).to eq(DateTime.new(2017, 10, 9, 9, 7, 0, 'CST'))
    expect(appt.comments).to eq('Test1Comment')

    expect_status 201
  end

# -------------------- Presence tests -----------------------------------------
  it "doesn't create a new appointment if there is no first_name" do

    url =
      "/appointments?last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last).to eq(nil)

  end
  it "doesn't create a new appointment if there is no last_name" do

    url =
      "/appointments?first_name=#{@first_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last).to eq(nil)

  end
  it "doesn't create a new appointment if there is no start_time" do

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last).to eq(nil)

  end
  it "doesn't create a new appointment if there is no end_time" do

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last).to eq(nil)

  end

# ---------------------------Date Validation Tests -----------------------------

  it "doesn't create a new appointment if start_date is not in the future" do

    @start_time = "10/9/2011 8:07"
    @end_time = "10/9/2011 9:07"

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last).to eq(nil)

  end

  it "doesn't create a new appointment if end_date is not after start_date" do

    @end_time = "10/9/2017 7:07"

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last).to eq(nil)

  end

  it "doesn't create a new appointment if an existing appointment starts "\
  "at the same time" do

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    # Create one test where other start_date causes conflict
    @first_name = "Test2FirstName"
    @last_name = "Test2LastName"
    @start_time = "10/9/2017 8:07"
    @end_time = "10/9/2017 9:00"
    @comments = "Test2Comment"

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    expect(Appointment.last.first_name).to eq("Test1FirstName".downcase)

  end

  it "doesn't create a new appointment if an existing appointment starts after "\
  "or ends before it's start_date and end_date respectively" do

    # Create first appointment normally
    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    # Create second appointment that has start_time between original
    @first_name = "Test2FirstName"
    @start_time = "10/9/2017 8:37"
    @end_time = "10/9/2017 9:37"

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    # Create third appointment that has end_time between original
    @first_name = "Test3FirstName"
    @start_time = "10/9/2017 8:37"
    @end_time = "10/9/2017 9:37"

    url =
      "/appointments?first_name=#{@first_name}&last_name=#{@last_name}&"\
      "start_time=#{@start_time}&end_time=#{@end_time}&comments=#{@comments}"

    post "#{url}"

    expect_status 400

    # Test to make sure only first appt exists

    expect(Appointment.all.length).to eq(1)
    expect(Appointment.last.first_name).to eq("Test1FirstName".downcase)

  end

  # Clear appointments after test is done
  after :all do
    Appointment.destroy_all
  end

end
