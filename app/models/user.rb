class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  has_secure_password
  
  has_many :events
end
