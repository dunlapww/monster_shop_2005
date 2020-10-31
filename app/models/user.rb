class User < ApplicationRecord
  has_secure_password validations: true
  validates :email_address, uniqueness: true, presence: true
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password_confirmation, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
  validates_presence_of :name, require: true
  validates_presence_of :address, require: true
  validates_presence_of :city, require: true
  validates_presence_of :state, require: true
  validates_presence_of :zip, require: true
  validates_presence_of :email_address, require: true
  enum role: %w(default merchant_employee admin)
  has_many :orders
end
