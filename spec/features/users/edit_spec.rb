
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
        click_on('Submit')
      end

      describe 'And I submit the form' do
        it 'Then I am returned to my profile page' do
          expect(current_path).to eq('/profile')
        end

        it 'And I see a flash message telling me that my data is updated, And I see my updated information' do
          expect(page).to have_content("Your profile has been updated!")
          expect(page).to have_content("BOBname")
          expect(page).to have_content("BOBaddress")
          expect(page).to have_content("BOBcity")
          expect(page).to have_content("BOBstate")
          expect(page).to have_content("BOBzip")
          expect(page).to have_content("BOBemail")
        end
      end
    end
  end
end
