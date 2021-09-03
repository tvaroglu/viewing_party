class Event < ApplicationRecord
  validates :movie_title, presence: true
  validates :movie_id, presence: true
  validates :event_date, presence: true
  validates :event_time, presence: true
  validates :runtime, presence: true
  belongs_to :user
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees

  def host
    user.email
  end

  def self.add_attendees(new_event, attendees, current_user)
    attendees.each { |user_email| Attendee.create(event: new_event, user: User.find_by(email: user_email)) }
    Attendee.create(event: new_event, user: current_user)
  end
end
