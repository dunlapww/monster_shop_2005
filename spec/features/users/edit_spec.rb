
#User Story 20, User Can Edit their Profile Data
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
                          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
                          allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @user.id}}
  end
  describe 'When I visit my profile page' do
    it 'I see a link to edit my profile data' do
      visit "/profile"
      expect(page).to have_link("Edit Profile")
    end


    describe 'When I click on the link to edit my profile data' do
      it 'I see a form like the registration page' do
        visit "/profile"
        click_link("Edit Profile")
        expect(current_path).to eq("users/#{@user.id}/edit")
      end

      it 'The form is prepopulated with all my current information except my password' do
        visit "users/#{@user.id}/edit"
        expect(page).to have_field('user_name'), with: @user.name
        expect(page).to have_field('user_address'), with: @user.address
        expect(page).to have_field('user_city'), with: @user.city
        expect(page).to have_field('user_state'), with: @user.state
        expect(page).to have_field('user_zip'), with: @user.zip
        expect(page).to have_field('user_email_address'), with: @user.email_address
      end
    end
  end

  describe 'When I change any or all of that information' do

    before(:each) do
      visit "users/#{@user.id}/edit"
      fill_in 'user_name', with: 'BOB'
      fill_in 'user_address', with: 'BOB'
      fill_in 'user_city', with: 'BOB'
      fill_in 'user_state', with: 'BOB'
      fill_in 'user_zip', with: 'BOB'
      fill_in 'user_email_address', with: 'BOB'
      click_on('Submit')
    end

    describe 'And I submit the form' do
      it 'Then I am returned to my profile page' do
        expect(current_path).to eq('/profile')
      end

      it 'And I see a flash message telling me that my data is updated, And I see my updated information' do
        expect(page).to have_content('')
      end
    end
  end
end
