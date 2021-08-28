class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.format_date(date)
    date.strftime("%A, %B %d, %Y")
  end

  def self.format_time(time)
    time.localtime.strftime("%I:%M %p")
  end
end
