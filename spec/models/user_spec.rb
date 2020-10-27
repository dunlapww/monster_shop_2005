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

describe User do
  describe "roles" do
    it "can be created as a default user" do
     user = User.create!({password: "testpass",
                             name: "testname",
                             address: "testaddress",
                             city: "testcity",
                             state: "teststate",
                             zip: "testzip",
                             email_address: "testemail",
                             password_confirmation: "testpass",
                             role: 0})

      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy
    end

    it "can be created as a merchant employee user" do
      user = User.create!({password: "testpass",
                             name: "testname",
                             address: "testaddress",
                             city: "testcity",
                             state: "teststate",
                             zip: "testzip",
                             email_address: "testemail",
                             password_confirmation: "testpass",
                             role: 1})

      expect(user.role).to eq("merchant_employee")
      expect(user.merchant_employee?).to be_truthy
    end
    it "can be created as an admin" do
      user = User.create!({password: "testpass",
                             name: "testname",
                             address: "testaddress",
                             city: "testcity",
                             state: "teststate",
                             zip: "testzip",
                             email_address: "testemail",
                             password_confirmation: "testpass",
                             role: 2})

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end
  end
end
