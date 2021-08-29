class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  has_secure_password
  has_many :events, dependent: :destroy
  has_many :attendees, through: :events
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Friendship', dependent: :destroy
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Friendship', dependent: :destroy
  has_many :followers, through: :following_users

  def friends?
    followers.count.positive?
  end

  def already_friends_with?(user_id)
    !followers.where(id: user_id).empty?
  end

  def self.events_invited_to(user_id)
    Event.select('events.*').joins(:attendees)
    .where('attendees.user_id = ?', user_id)
    .where('events.user_id <> ?', user_id)
  end
end
