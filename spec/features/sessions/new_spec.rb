require 'rails_helper'

# As a visitor
# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in

describe 'as a visitor' do
  describe "when I visit login path" do
    before :each do
      @user = User.create!({password: "userpass",
                             name: "username",
                             address: "useraddress",
                             city: "usercity",
                             state: "userstate",
                             zip: "userzip",
                             email_address: "useremail",
                             password_confirmation: "userpass",
                             role: 0})
      @merchant = User.create!({password: "merchantpass",
                             name: "merchantname",
                             address: "merchantaddress",
                             city: "merchantcity",
                             state: "merchantstate",
                             zip: "merchantzip",
                             email_address: "merchantemail",
                             password_confirmation: "merchantpass",
                             role: 1})
      @admin = User.create!({password: "adminpass",
                             name: "adminname",
                             address: "adminaddress",
                             city: "admincity",
                             state: "adminstate",
                             zip: "adminzip",
                             email_address: "adminemail",
                             password_confirmation: "adminpass",
                             role: 2})

    end
    it "as a user, I see a field to enter my email and password" do
      visit '/login'

      fill_in :email_address, with: @user.email_address
      fill_in :password, with: @user.password

      click_on("Log In")
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Thank you for logging in #{@user.name}")
    end

    it "as a merchant, I see a field to enter my email and password" do
      visit '/login'

      fill_in :email_address, with: @merchant.email_address
      fill_in :password, with: @merchant.password

      click_on("Log In")
      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Thank you for logging in #{@merchant.name}")
    end
  end
end
