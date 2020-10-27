require 'rails_helper'

describe "as a visitor" do
  describe "when click on the 'register' link in the nav bar I am redirected to a form" do
    it "then I fill in a user information, click 'Submit' and I see my profile" do
      visit '/merchants'

      within 'nav' do
        click_link("Register")
      end

      expect(current_path).to eq("/register")

      fill_in :name, with: "Joe"
      fill_in :address, with: "123 Joe St."
      fill_in :city, with: "Joesville"
      fill_in :state, with: "KY"
      fill_in :zip, with: "81620"
      fill_in :email_address, with: "joe@example.com"
      fill_in :password, with: "Joeisthebest!"
      fill_in :password_confirmation, with: "Joeisthebest!"

      click_on("Submit")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Thank you for logging in Joe")
    end
  end

  describe "When I visit the user registration page" do
    describe "And I do not fill in this form completely," do
      it "I am returned to the registration page and told i did something wrong" do
        visit('/register')
        fill_in :name, with: "Joe"
        fill_in :address, with: "123 Joe St."
        fill_in :city, with: "Joesville"
        fill_in :state, with: "KY"
        fill_in :zip, with: "81620"
        fill_in :password, with: "Joeisthebest!"
        fill_in :password_confirmation, with: "Joeisthebest!"
        click_on("Submit")
        expect(page).to have_content("User not created, missing required field inputs")
        expect(current_path).to eq("/register")
      end

      it "I am returned to the registration page and told i did something wrong" do
        visit('/register')
        fill_in :name, with: "Joe"
        fill_in :address, with: "123 Joe St."
        fill_in :city, with: "Joesville"
        fill_in :state, with: "KY"
        fill_in :zip, with: "81620"
        fill_in :email_address, with: "joe@example.com"
        fill_in :password, with: "Joeisthebest!"
        click_on("Submit")
        expect(page).to have_content("User not created, missing required field inputs")
        expect(current_path).to eq("/register")
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
              it "I see a flash message telling me the email address is already in use"
              current_user = User.create!({name: "Joe",
                                           address: "123 Joe St.",
                                           city: "Joesville",
                                           state: "KY",
                                           zip: "81620",
                                           email_address: "joe@example.com",
                                           password: "Joeisthebest!",
                                           password_confirmation: "Joeisthebest!"})

              visit('/register')
              fill_in :name, with: "Jim"
              fill_in :address, with: "123 Jim St."
              fill_in :city, with: "Jimsville"
              fill_in :state, with: "KY"
              fill_in :zip, with: "81620"
              fill_in :email_address, with: "joe@example.com"
              fill_in :password, with: "Jimisthebest!"
              fill_in :password_confirmation, with: "Jimisthebest!"

              click_on("Submit")
              expect(page).to have_content("E-mail already taken, please input another!") 
            end
          end
        end
      end
    end
  end
end
