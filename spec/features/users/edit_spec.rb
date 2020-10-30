
#User Story 20, User Can Edit their Profile Data
require 'rails_helper'
feature "edit user" do
  given!(:user) { create(:user, email_address: 'jack@daniels.com') }
  describe 'As a registered user' do
    describe 'When I visit my profile page' do
      it 'I see a link to edit my profile data' do
        page.set_rack_session(user_id: user.id)
        visit "/profile"
        expect(page).to have_link("Edit Profile")
      end


      describe 'When I click on the link to edit my profile data' do
        it 'I see a form like the registration page' do
          page.set_rack_session(user_id: user.id)
          visit "/profile"
          click_link("Edit Profile")
          expect(current_path).to eq("/profile/edit")
        end

        it 'The form is prepopulated with all my current information except my password' do
          page.set_rack_session(user_id: user.id)
          visit "/profile/edit"
          expect(page).to have_field 'user_name', with: user.name
          expect(page).to have_field 'user_address', with: user.address
          expect(page).to have_field 'user_city', with: user.city
          expect(page).to have_field 'user_state', with: user.state
          expect(page).to have_field 'user_zip', with: user.zip
          expect(page).to have_field 'user_email_address', with: user.email_address
        end
      end
    end

    describe 'When I change any or all of that information' do

      before(:each) do
        page.set_rack_session(user_id: user.id)
        visit "/profile/edit"
        fill_in 'user_name', with: 'BOBname'
        fill_in 'user_address', with: 'BOBaddress'
        fill_in 'user_city', with: 'BOBcity'
        fill_in 'user_state', with: 'BOBstate'
        fill_in 'user_zip', with: 'BOBzip'
        fill_in 'user_email_address', with: 'BOBemail'
      end

      describe 'And I submit the form' do
        it 'Then I am returned to my profile page' do
          click_on('Submit')
          expect(current_path).to eq('/profile')
        end

        it 'And I see a flash message telling me that my data is updated, And I see my updated information' do
          click_on('Submit')
          expect(page).to have_content("Your profile has been updated!")
          expect(page).to have_content("BOBname")
          expect(page).to have_content("BOBaddress")
          expect(page).to have_content("BOBcity")
          expect(page).to have_content("BOBstate")
          expect(page).to have_content("BOBzip")
          expect(page).to have_content("BOBemail")
        end
        
        it "gives an error if I input the same email as a existing user" do
          create(:user, email_address: "BOBemail")
          click_on('Submit')
          expect(page).to have_content("Email address has already been taken")
          expect(page).to have_field("user_address")
          expect(page).to have_field("user_zip")
        end
      end
    end
  end
 
  #User Story 21, User Can Edit their Password
  describe "When I visit my profile page" do
    before(:each) do
      page.set_rack_session(user_id: user.id)
    end

    it "I see a link to edit my password" do
      visit "/profile"
      expect(page).to have_link("Edit Password")
    end

    describe "When I click on the link to edit my password" do
      it "I see a form with fields for a new password, and a new password confirmation" do
        visit "/profile"
        click_on('Edit Password')
        expect(current_path).to eq("/profile/edit_password")
        expect(page).to have_field("user_password")
        expect(page).to have_field("user_password_confirmation")
      end
    end
    
    describe "When I fill in the same password in both fields" do
      describe "And I submit the form" do
        describe "Then I am returned to my profile page" do
          it "And I see a flash message telling me that my password is updated" do
            visit "/profile/edit_password"
            fill_in 'user_password', with: 'NewPassword'
            fill_in 'user_password_confirmation', with: 'NewPassword'
            click_on("Submit")
            expect(current_path).to eq("/profile")
          end

          it "If I input passwords that don't match I am given an error and returned to the same page" do;
            visit "/profile/edit_password"
            fill_in 'user_password', with: 'NewPassword'
            fill_in 'user_password_confirmation', with: 'NewPass'
            click_on("Submit")
            expect(page).to have_content("Password confirmation doesn't match Password")
            expect(page).to have_field("user_password")
            expect(page).to have_field("user_password_confirmation")
          end
        end
      end
    end
  end
end
