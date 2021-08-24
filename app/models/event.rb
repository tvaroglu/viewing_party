class Event < ApplicationRecord
  validates_presence_of [:movie_title, :event_date, :event_time, :runtime]
  belongs_to :user
end
