class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.format_date(date)
    date.strftime('%B %d, %Y')
  end

  def self.format_time(time)
    time.strftime('%I:%M %p')
  end

  def self.parse_event_time(time_params)
    Time.parse("#{time_params['event_time(1i)']}-#{time_params['event_time(2i)']}-#{time_params['event_time(3i)']}-#{time_params['event_time(4i)']}-#{time_params['event_time(5i)']}")
  end
end
