class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  has_secure_password

end
