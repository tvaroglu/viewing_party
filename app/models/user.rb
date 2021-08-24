class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  has_secure_password
  has_many :attendees, dependent: :destroy
  has_many :events, through: :attendees
  # 8/24: Rubocop offense: including :inverse_of
  # app/models/user.rb:6:3: C: Rails/InverseOf: Specify an :inverse_of option.
  # has_many :followed_users, foreign_key: :follower_id, class_name: 'Friendship'
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Friendship', dependent: :destroy
  has_many :followees, through: :followed_users
  # 8/24: Rubocop offense: including :inverse_of
  # app/models/user.rb:8:3: C: Rails/InverseOf: Specify an :inverse_of option.
  # has_many :following_users, foreign_key: :followee_id, class_name: 'Friendship'
  has_many :following_users, foreign_key: :followee_id, class_name: 'Friendship', dependent: :destroy
  has_many :followers, through: :following_users
end
