class User < ApplicationRecord
  has_many :tasks
  
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([a-zA-Z]{2,})\z/i
  validates :email, :password_digest, presence: true, uniqueness: true
  has_secure_password
end
