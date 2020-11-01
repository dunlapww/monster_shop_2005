require 'rails_helper'

feature 'Admin merchant index' do
  given!(:user) {@admin = create(:user, role: 2)}
  describe 'When I visit the merchant index page' do
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

    it 'I see a list of merchants' do
      visit '/merchants'
      click_link("#{@merchant1.name}")
      expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
    end
  end  
end
