require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of(:password)}
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip)}
    it {should validate_uniqueness_of(:email_address)}
    it {should validate_confirmation_of(:password)}
    it {should validate_presence_of(:password_confirmation)}
  end
end
