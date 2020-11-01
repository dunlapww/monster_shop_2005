require 'rails_helper'

feature 'Admin merchant show' do
  given!(:user) {@admin = create(:user, role: 2)}
  describe 'When I visit an admin merchant show page' do
    before :each do
      @merchant1 = create(:merchant)
      @merchant_employee = create(:user, role: 1)
      @merchant1.users << @merchant_employee
      page.set_rack_session(user_id: @admin.id)
      @customer1 = create(:user)
      @customer2 = create(:user)
      @order1 = create(:order, user_id: @customer1.id)
      @order2 = create(:order, user_id: @customer2.id, status: "shipped")
      @order3 = create(:order, user_id: @customer2.id)
      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant1.id)
      @item3 = create(:item, merchant_id: @merchant1.id)
      create(:item_order, order_id: @order1.id, item_id: @item1.id)
      create(:item_order, order_id: @order1.id, item_id: @item3.id)
      create(:item_order, order_id: @order2.id, item_id: @item2.id)
      create(:item_order, order_id: @order3.id, item_id: @item1.id)
    end

    it "I see the name an full address of the merchant I'm viewing" do
      visit "/admin/merchants/#{@merchant1.id}"
      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant1.address)
      expect(page).to have_content(@merchant1.city)
      expect(page).to have_content(@merchant1.state)
      expect(page).to have_content(@merchant1.zip)
    end

    it "I see any pending orders that contain their items and thos orders details" do
      visit "/admin/merchants/#{@merchant1.id}"
      within "#order-#{@order1.id}" do
        expect(page).to have_link("#{@order1.id}")
        expect(page).to have_content(@order1.created_at.to_date)
        expect(page).to have_content(@order1.merchant_items_qty(@merchant1.id))
        expect(page).to have_content(@order1.merchant_items_value(@merchant1.id))
      end
      expect(page).to_not have_selector("#order-#{@order2.id}")
    end

    it 'I see a link to that merchants items' do
      visit "/admin/merchants/#{@merchant1.id}"

      click_link("My Merchant Items")
      expect(current_path).to eq('/merchant/items')
    end
  end
end
