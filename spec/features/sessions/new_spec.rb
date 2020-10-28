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
      @new_merchant = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @new_merchant.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @new_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      # allow_any_instance_of(ActionDispatch::Request).to receive(:session){{user_id: @merchant.id, cart: {@tire.name => @tire.id, @pull_toy.name => @pull_toy.id}}}
      
      
      visit '/merchants'
      expect(page).to have_content("Cart: 2")
      click_link('Log Out')
      expect(current_path).to eq('/')
      expect(page).to have_content("You have successfully logged out")
      expect(page).to have_content("Cart: 0")
      
    end
  end
end
