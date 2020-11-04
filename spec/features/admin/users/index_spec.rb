require 'rails_helper'

feature 'Admin user index' do
  given!(:user) { @admin = create(:user, role: 2)}
  describe 'As an admin' do
    before :each do
      page.set_rack_session(user_id: @admin.id)
      @user1 = create(:user, role: 1)
      @user2 = create(:user, role: 0)
      @user3 = create(:user, role: 2)
    end

    it 'I visit users index and see all users details' do
      visit '/admin'

      within("nav") do
        click_link("Users")
      end

      expect(current_path).to eq('/admin/users')

      within("#user-#{@user1.id}") do
        expect(page).to have_link(@user1.name)
        expect(page).to have_content(@user1.created_at)
        expect(page).to have_content(@user1.role)
      end

      within("#user-#{@user2.id}") do
        expect(page).to have_link(@user2.name)
        expect(page).to have_content(@user2.created_at)
        expect(page).to have_content(@user2.role)
      end

      within("#user-#{@user3.id}") do
        expect(page).to have_content(@user3.created_at)
        expect(page).to have_content(@user3.role)
        expect(page).to have_link(@user3.name)
      end
    end

    it 'I click a users name and it take me to their show page' do
      visit('/admin/users')

      within("#user-#{@user2.id}") do
        click_link(@user2.name)
      end

      expect(current_path).to eq("/admin/users/#{@user2.id}")
    end
  end
end
