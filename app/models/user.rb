class User < ApplicationRecord
  before_destroy :last_user?

  has_many :tasks, dependent: :destroy
  
  validates :email, :password_digest, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([a-zA-Z]{2,})\z/i
  has_secure_password

  private

  def last_user?
    throw :abort if User.count < 1
  end
end
