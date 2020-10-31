require 'rails_helper'

feature 'user show page' do
  given!(:user) {create(:user)}
  describe 'As a registered user' do
    before(:each) do
      page.set_rack_session(user_id: user.id)
      create_list(:merchant, 2)
      @order1 = create(:order, user_id: user.id)
      @order2 = create(:order, user_id: user.id)
      create_list(:item_order, 5, order_id: @order1.id)
      create_list(:item_order, 5, order_id: @order2.id)
    end

#     As a registered user
# When I visit my Profile Orders page
# And I click on a link for order's show page
# My URL route is now something like "/profile/orders/15"
# I see all information about the order, including the following information:
# - the ID of the order
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - each item I ordered, including name, description, thumbnail, quantity, price and subtotal
# - the total quantity of items in the whole order
# - the grand total of all items for that order

    describe 'as a registered user' do
      describe "when I visit my Profile Orders page and I click on a link for order's show page" do
        it "route is /profile/orders/:order_id and I see details of the order" do
          visit("/profile/orders")
          click_link("order-#{@order1.id}")

          expect(current_path).to eq("/profile/orders/#{@order1.id}")

          expect(page).to have_content("#{@order1.id}")
          expect(page).to have_content("#{@order1.created_at.strftime("%m-%d-%Y")}")
          expect(page).to have_content("#{@order1.updated_at.strftime("%m-%d-%Y")}")
          expect(page).to have_content("#{@order1.status}")
          expect(page).to have_content("#{@order1.quantity_of_items}")
          expect(page).to have_content("#{@order1.grandtotal.round(2)}")

          item1 = @order1.items.first
          item2 = @order1.items.second
          item_order1 = @order1.item_orders.first
          item_order2 = @order1.item_orders.second

          within("#item-#{item_order1.item_id}") do
            expect(page).to have_content("#{item1.name}")
            expect(page).to have_content("#{item1.description}")
            expect(page).to have_content("#{item1.image}")
            expect(page).to have_content("#{item_order1.quantity}")
            expect(page).to have_content("#{item_order1.subtotal.round(2)}")
          end

          within("#item-#{item_order2.item_id}") do
            expect(page).to have_content("#{item2.name}")
            expect(page).to have_content("#{item2.description}")
            expect(page).to have_content("#{item2.image}")
            expect(page).to have_content("#{item_order2.quantity}")
            expect(page).to have_content("#{item_order2.subtotal.round(2)}")
          end
        end
      end
    end
  end
end
