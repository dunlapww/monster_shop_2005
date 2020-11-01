require 'rails_helper'

# As a merchant employee
# When I visit my merchant dashboard ("/merchant")
# I see the name and full address of the merchant I work for

feature 'As a merchant' do
  given!(:user) {@merchant_employee = create(:user, role: 1)}
  describe "When I visit my merchant dashboard ('/merchant')" do
    before :each do
      @merchant1 = create(:merchant)
      @merchant1.users << @merchant_employee
      page.set_rack_session(user_id: @merchant_employee.id)
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
    it "I see the name an full address of the merchant I work for" do
      visit "/merchant"
      expect(page).to have_content(@merchant_employee.merchant.name)
      expect(page).to have_content(@merchant_employee.merchant.address)
      expect(page).to have_content(@merchant_employee.merchant.city)
      expect(page).to have_content(@merchant_employee.merchant.state)
      expect(page).to have_content(@merchant_employee.merchant.zip)
    end
    it "I see any pending orders that contain items of mine and their details" do
      visit "/merchant"
      within "#order-#{@order1.id}" do
        expect(page).to have_link(@order1.id)
        expect(page).to have_content(@order1.created_at.to_date)
        expect(page).to have_content(@order1.merchant_items_qty(@merchant1.id))
        expect(page).to have_content(@order1.merchant_items_value(@merchant1.id))
      end
      expect(page).to_not have_selector("#order-#{@order2.id}")
    end
  end
end
