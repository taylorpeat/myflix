class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items

  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates :full_name, presence: true
end
