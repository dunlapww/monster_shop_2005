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

    describe 'I see a list of all my orders including many details:' do
      it 'order ID as link, creation date, order updated, status, quantity of items, grand_total of items' do
        visit "/profile/orders"

        within("#order-#{@order1.id}") do
          expect(page).to have_link("order-#{@order1.id}")
          expect(page).to have_content("#{@order1.created_at.strftime("%m-%d-%Y")}")
          expect(page).to have_content("#{@order1.updated_at.strftime("%m-%d-%Y")}")
          expect(page).to have_content("#{@order1.status}")
          expect(page).to have_content("#{@order1.quantity_of_items}")
          expect(page).to have_content("#{@order1.grandtotal.round(2)}")
        end
      end
    end
  end
end
