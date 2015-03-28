class User < ActiveRecord::Base
  has_secure_password validations: false
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 8
  validates_presence_of :email
  validates_uniqueness_of :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, with: VALID_EMAIL_REGEX
  has_many :chains
end
