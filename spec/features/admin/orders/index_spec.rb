require 'rails_helper'

feature 'Admin users order index' do
  given!(:user) { @admin = create(:user, role: 2) }
  describe "When I visit an admin view of a users orders" do
    before :each do
      page.set_rack_session(user_id: @admin.id)
      @user = create(:user, role: 0)
      @order1 = create(:order, user_id: @user.id)
      @order2 = create(:order, user_id: @user.id)
      @item_order1 = create(:item_order, order_id: @order1.id)
      @item_order1 = create(:item_order, order_id: @order1.id)
    end

    it "I see everything a user would see" do
      visit "/admin/users/#{@user.id}/orders"

      within("#order-#{@order1.id}") do
        expect(page).to have_link("Order-#{@order1.id}")
        expect(page).to have_content(@order1.created_at)
        expect(page).to have_content(@order1.updated_at)
        expect(page).to have_content(@order1.status)
        expect(page).to have_content(@order1.quantity_of_items)
        expect(page).to have_content(@order1.grandtotal)
      end

      within("#order-#{@order2.id}") do
        expect(page).to have_link("Order-#{@order2.id}")
        expect(page).to have_content(@order2.created_at)
        expect(page).to have_content(@order2.updated_at)
        expect(page).to have_content(@order2.status)
        expect(page).to have_content(@order2.quantity_of_items)
        expect(page).to have_content(@order2.grandtotal)
      end
    end
  end
end
