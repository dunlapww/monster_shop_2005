#User Story 19, User Profile Show Page
require 'rails_helper'
describe 'As a registered user' do
  before(:each) do
  @user = User.create!({password: "userpass",
                         name: "username",
                         address: "useraddress",
                         city: "usercity",
                         state: "userstate",
                         zip: "userzip",
                         email_address: "useremail",
                         password_confirmation: "userpass",
                         role: 0})
    allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @user.id}}
  end
  describe 'When I visit my profile page' do
    it 'Then I see all of my profile data on the page except my password' do
      visit 'profile'
      expect(page).to have_content("#{@user.name}")
      expect(page).to have_content("#{@user.address}")
      expect(page).to have_content("#{@user.city}")
      expect(page).to have_content("#{@user.state}")
      expect(page).to have_content("#{@user.zip}")
      expect(page).to have_content("#{@user.email_address}")
      expect(page).to_not have_content("#{@user.password}")
    end
    it 'And I see a link to edit my profile data' do
      visit 'profile'
      expect(page).to have_link("Edit Profile")
    end
  end
end
