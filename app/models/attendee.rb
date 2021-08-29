class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :event

  def user_email
    user.email
  end
end
