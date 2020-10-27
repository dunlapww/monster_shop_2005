class User < ApplicationRecord
  validates :email_address, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  validates_presence_of :name, require: true
  validates_presence_of :address, require: true
  validates_presence_of :city, require: true
  validates_presence_of :state, require: true
  validates_presence_of :zip, require: true
  validates_presence_of :email_address, require: true

  validates_confirmation_of :password
  validates_presence_of :password_confirmation

  has_secure_password validations: false

end
