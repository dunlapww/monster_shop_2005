require 'rails_helper'

feature 'user show page' do
  given!(:user) {create(:user)}
  describe 'As a registered user' do
    before(:each) do
      page.set_rack_session(user_id: user.id)
      create_list(:merchant, 2)
      @order1 = create(:order, user_id: user.id)
      @order2 = create(:order, user_id: user.id)
      @order1.items << create_list(:item, 5)
      @order2.items << create_list(:item, 5)
    end

    describe 'I see a list of all my orders including many details:' do
      it 'order ID as link, creation date, order updated, status, quantity of items, grand_total of items' do
        visit "/profile/orders"
        
      end
    end
  end
end

