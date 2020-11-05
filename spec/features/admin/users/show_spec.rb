require 'rails_helper'

feature 'Admin user show' do
  given!(:user) { @admin = create(:user, role: 2)}
  describe "When I visit a user show page" do
    before :each do
      page.set_rack_session(user_id: @admin.id)
      @user = create(:user, role: 0)
    end

    it "I see everything that user would see, but no link to edit profile" do
      visit "/admin/users/#{@user.id}"

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email_address)

      expect(page).to have_link("User's Orders")
    end

    it "I can click on a link to see that user's orders" do
      visit "/admin/users/#{@user.id}"
      click_link("User's Orders")
      
      expect(current_path).to eq("/admin/users/#{@user.id}/orders")
    end
  end
end
