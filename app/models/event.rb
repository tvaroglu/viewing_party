class Event < ApplicationRecord
  validates :movie_title, presence: true
  validates :event_date, presence: true
  validates :event_time, presence: true
  validates :runtime, presence: true
  belongs_to :user
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees

  def host
    user.email
  end
end
