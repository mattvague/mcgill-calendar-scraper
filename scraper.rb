require 'rubygems'
require 'mechanize'
require 'chronic'
require 'icalendar'

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

a.get('https://www.mcgill.ca/importantdates/key-dates') do |page|
  cal = Icalendar::Calendar.new

  page.css('.field-item.even ul li').each do |line|
    name = line.text.strip.split(', ')[0]
    date = line.text.strip.split(', ')[1]
    end_date = date

    if parsed_date = Chronic.parse(date)
      cal.event do |e|
        e.dtstart     = Icalendar::Values::Date.new(parsed_date)
        e.dtend       = Icalendar::Values::Date.new(parsed_date)
        e.summary     = name
        e.summary     = name

        e.alarm do |a|
          a.action          = "DISPLAY"
          a.trigger         = "-PT1D"
        end

        e.alarm do |a|
          a.action          = "DISPLAY"
          a.trigger         = "PT9H"
        end
      end
    end
  end

  puts 'Writing...'
  File.open('mcgill_academic_dates.ics', 'w') do |file|
    file.write(cal.to_ical)
  end
  puts 'Written to ~/mcgill_academic_dates.ics'
end
