require 'rails_helper'

describe "as a visitor" do
  describe "when click on the 'register' link in the nav bar I am redirected to a form" do
    it "then I fill in a user information, click 'Submit' and I see my profile" do
      visit '/merchants'

      within 'nav' do
        click_link("Register")
      end

      expect(current_path).to eq("/register")

      fill_in "user_name", with: "Joe"
      fill_in "user_address", with: "123 Joe St."
      fill_in "user_city", with: "Joesville"
      fill_in "user_state", with: "KY"
      fill_in "user_zip", with: "81620"
      fill_in "user_email_address", with: "joe@example.com"
      fill_in "user_password", with: "Joeisthebest!"
      fill_in "user_password_confirmation", with: "Joeisthebest!"

      click_on("Submit")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Thank you for logging in Joe")
    end
  end

  describe "When I visit the user registration page" do
    describe "And I do not fill in this form completely," do
      it "I am returned to the registration page and told i did something wrong" do
        visit('/register')
        fill_in "user_name", with: "Joe"
        fill_in "user_address", with: "123 Joe St."
        fill_in "user_city", with: "Joesville"
        fill_in "user_state", with: "KY"
        fill_in "user_zip", with: "81620"
        fill_in "user_password", with: "Joeisthebest!"
        fill_in "user_password_confirmation", with: "Joeisthebest!"
        click_on("Submit")
        expect(page).to have_content("Email address can't be blank")
      end

      it "I am returned to the registration page and told i did something wrong" do
        visit('/register')
        fill_in "user_name", with: "Joe"
        fill_in "user_address", with: "123 Joe St."
        fill_in "user_city", with: "Joesville"
        fill_in "user_state", with: "KY"
        fill_in "user_zip", with: "81620"
        fill_in "user_email_address", with: "joe@example.com"
        fill_in "user_password", with: "Joeisthebest!"
        click_on("Submit")
        expect(page).to have_content("Password confirmation doesn't match Password")
      end
    end
  end

#User Story 12, Registration Email must be unique
  describe "When I visit the user registration page" do
    describe "If I fill out the registration form" do
      describe "But include an email address already in the system" do
        describe "Then I am returned to the registration page" do
          describe "My details are not saved and I am not logged in" do
            describe "The form is filled in with all previous data except the email field and password fields" do
              it "I see a flash message telling me the email address is already in use" do
                current_user = User.create!({name: "James",
                address: "123 James St.",
                city: "Jamessville",
                state: "KY",
                zip: "81620",
                email_address: "james@example.com",
                password: "Jamesisthebest!",
                password_confirmation: "Jamesisthebest!"})

                visit('/register')

                fill_in "user_name", with: "Jim"
                fill_in "user_address", with: "123 Jim St."
                fill_in "user_city", with: "Jimsville"
                fill_in "user_state", with: "KY"
                fill_in "user_zip", with: "81620"
                fill_in "user_email_address", with: "james@example.com"
                fill_in "user_password", with: "Jimisthebest!"
                fill_in "user_password_confirmation", with: "Jimisthebest!"

                click_on("Submit")
                expect(page).to have_content("Email address has already been taken")
                expect(page).to have_field 'user[name]', with: "Jim"
                expect(page).to have_field 'user[address]', with: "123 Jim St."
                expect(page).to have_field 'user[city]', with: "Jimsville"
                expect(page).to have_field 'user[state]', with: "KY"
                expect(page).to have_field 'user[zip]', with: "81620"
              end
            end
          end
        end
      end
    end
  end
end
