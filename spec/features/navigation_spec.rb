
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end
    # User Story 2, Visitor Navigation

    # As a visitor
    # I see a navigation bar
    # This navigation bar includes links for the following:
    # - a link to return to the welcome / home page of the application ("/")
    # - a link to browse all items for sale ("/items")
    # - a link to see all merchants ("/merchants")
    # - a link to my shopping cart ("/cart")
    # - a link to log in ("/login")
    # - a link to the user registration page ("/register")

    # Next to the shopping cart link I see a count of the items in my cart

    describe 'As a vistor' do
      describe 'I see a navigation bar with several links including:' do

        it "a link to return to the welcome / home page of the application ('/')" do
          visit '/merchants'
          within 'nav' do
            click_link("Welcome")
            expect(current_path).to eq("/")
          end
        end

        it "a link to browse all items for sale ('/items')" do
          visit '/merchants'
          within 'nav' do
            click_link("Items")
            expect(current_path).to eq("/items")
          end
        end

        it "a link to my shopping cart ('/cart')" do
          visit '/merchants'
          within 'nav' do
            click_link("Cart")
            expect(current_path).to eq("/cart")
          end
        end

        it "a link to log in ('/login')" do
          visit '/merchants'
          within 'nav' do
            click_link("Login")
            expect(current_path).to eq("/login")
          end
        end

        it "a link to the user registration page ('/register')" do
          visit '/merchants'
          within 'nav' do
            click_link("Register")
            expect(current_path).to eq("/register")
          end
        end
      end
    end
  end
  #User Story 3, User Navigation
  describe "I see the same links as a visitor" do
    before(:each) do
      @user1 = User.create!({password: "testpass",
                             name: "testname",
                             address: "testaddress",
                             city: "testcity",
                             state: "teststate",
                             zip: "testzip",
                             email_address: "testemail",
                             password_confirmation: "testpass",
                             role: 0})

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end
    it "Plus the following links" do
      expect(page).to have_link("profile")
      expect(page).to have_link("logout")
      expect(page).to have_content("Hello #{@user1.name}!")
    end
    it "Minus the following links" do
      expect(page).to_not have_link "Log In"
      expect(page).to_not have_link "Register"
    end
  end
end
