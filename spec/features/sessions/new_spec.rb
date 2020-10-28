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

    it "as a admin, I see a field to enter my email and password" do
      visit '/login'

      fill_in :email_address, with: @admin.email_address
      fill_in :password, with: @admin.password

      click_on("Log In")
      expect(current_path).to eq("/admin")
      expect(page).to have_content("Thank you for logging in #{@admin.name}")
    end

    it "as any user, if I login with bad credentials, I returned to login page" do
      visit '/login'

      fill_in :email_address, with: "bademail"
      fill_in :password, with: @admin.password

      click_on("Log In")
      expect(page).to have_content("Invalid credentials, please try again")
      expect(page).to have_field(:email_address)
      expect(page).to have_field(:password)

      fill_in :email_address, with: @admin.email_address
      fill_in :password, with: "badpassword"

      click_on("Log In")
      expect(page).to have_content("Invalid credentials, please try again")
      expect(page).to have_field(:email_address)
      expect(page).to have_field(:password)

    end

    describe "and I'm already logged in:" do
      it "as a user, i'm redirected to /profile" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @user.id}}
        visit '/login'

        expect(current_path).to eq('/profile')
      end

      it "as a merchant, i'm redirected to /merchant" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @merchant.id}}
        visit '/login'
        expect(current_path).to eq('/merchant')
      end

      it "as a admin, i'm redirected to /admin" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @admin.id}}
        visit '/login'
        expect(current_path).to eq('/admin')
      end
    end

    it "after I've logged in, I can log out" do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit '/merchants'

      within 'nav' do
        click_link("Register")
      end

      fill_in "user_name", with: "Joe"
      fill_in "user_address", with: "123 Joe St."
      fill_in "user_city", with: "Joesville"
      fill_in "user_state", with: "KY"
      fill_in "user_zip", with: "81620"
      fill_in "user_email_address", with: "joe@example.com"
      fill_in "user_password", with: "Joeisthebest!"
      fill_in "user_password_confirmation", with: "Joeisthebest!"

      click_on("Submit")

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      # allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @merchant.id, cart: {@tire.name => @tire.id, @pull_toy.name => @pull_toy.id}}}

      visit '/merchants'
      expect(page).to have_content("Cart: 3")
      click_link('Log Out')
      expect(current_path).to eq('/')
      expect(page).to have_content("You have successfully logged out")
      expect(page).to have_content("Cart: 0")

    end
  end
end
