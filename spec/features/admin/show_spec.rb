require 'rails_helper'

# As an admin user
# When I visit my admin dashboard ("/admin")
# Then I see all orders in the system.
# For each order I see the following information:

# - user who placed the order, which links to admin view of user profile
# - order id
# - date the order was created

# Orders are sorted by "status" in this order:

# - packaged
# - pending
# - shipped
# - cancelled

describe 'As an admin' do
  before :each do
    @admin = create(:user, role: 2)
    @customer1 = create(:user)
    @customer2 = create(:user)
    create_list(:merchant, 2)
    @order1 = create(:order, user_id: @customer1.id)
    @order2 = create(:order, user_id: @customer2.id)
    create_list(:item_order, 5, order_id: @order1.id)
    create_list(:item_order, 5, order_id: @order2.id)
  end
  describe 'When I visit my show page: /admin' do
    it 'I see all orders in system and their details' do
      visit "/login"
      fill_in :email_address, with: "#{@admin.email_address}"
      fill_in :password, with: "#{@admin.password}"
      click_on("Log In")
      expect(current_path).to eq("/admin")
      
      Order.all.each do |order|
        within("#order-#{order.id}") do
          expect(page).to have_link(order.user.name)
          expect(page).to have_content(order.id)
          expect(page).to have_content(order.created_at.to_date)
        end
      end
    end
  end
end
