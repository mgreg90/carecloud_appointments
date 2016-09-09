# Beginning parse appt_data.csv and turn each line into an appointment

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'appt_data.csv'))
csv = csv_text.split("\r\r\n").collect do |x|
  x.split(',')
end
csv.shift

csv.each do |row|
  a = Appointment.new
  a.start_time = DateTime.strptime("#{row[0]} EST", '%m/%d/%Y %H:%M %Z') + 2000.years
  a.end_time = DateTime.strptime("#{row[1]} EST", '%m/%d/%Y %H:%M %Z') + 2000.years
  a.first_name = row[2].downcase
  a.last_name = row[3].downcase
  a.comments = row[4] if !(row[4].nil?)
  if a.save(validate: false) # This had to be false because validation would
                             # prevent new appointments from being scheduled
                             # in the past
    puts "#{a.first_name} #{a.last_name}'s appointment is saved."
    puts "Starts at #{a.start_time} and ends at #{a.end_time}"
    puts "*" * 60
  else
    puts "\tS A V E  F A I L E D"
    puts "*" * 60
  end
end

# End parse appt_data.csv and turn each line into an appointment
