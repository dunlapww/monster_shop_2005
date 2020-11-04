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
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    end

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
          
          expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@order1.grandtotal))

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
            expect(page).to have_content("#{ActionController::Base.helpers.number_to_currency(item_order2.subtotal)}")
          end
        end
        it "has button to cancel order" do

          order = user.orders.create!(name: "Stuff",
                                      address: "There",
                                      city: "here",
                                      state: "CO",
                                      zip: 98798)
          paper = @mike.items.create!(name: "Lined Paper",
                                      description: "Great for writing on!",
                                      price: 20,
                                      image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png",
                                      inventory: 25)
          item1_inventory = paper.inventory

          item_order1 = ItemOrder.create!(order_id: order.id,
                           item_id: paper.id,
                           price: paper.price,
                           quantity: 5)
          item1_stock = item_order1.quantity

          visit("/profile/orders/#{order.id}")

          expect(user.orders.last.item_orders.first.status).to eq("pending")

          click_button("Cancel Order")

          expect(current_path).to eq("/profile")
          expect(page).to have_content("Order Cancelled")
          expect(user.orders.last.item_orders.first.status).to eq("unfulfilled")
          expect(user.orders.last.status).to eq("cancelled")
          expect(@mike.items.first.inventory).to eq(paper.inventory + item1_stock)
        end
        it 'cancel button does not exist if order status is shipped' do
          @order1.update(status: "shipped")
          
          visit("/profile/orders/#{@order1.id}")
          expect(page).to_not have_button("Cancel Order")
        end
      end
    end
  end
end
