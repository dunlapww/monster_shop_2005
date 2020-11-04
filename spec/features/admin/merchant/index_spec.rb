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
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant, active?: false)
      create(:item, merchant_id: @merchant3.id, active?: false)
      create(:item, merchant_id: @merchant3.id, active?: false)
      create(:item, merchant_id: @merchant3.id, active?: false)
    end

    it 'I see the merchants city and state' do
      visit '/admin/merchants'
      within("#merchant-#{@merchant1.id}") do
        expect(page).to have_content(@merchant1.name)
        expect(page).to have_content(@merchant1.city)
        expect(page).to have_content(@merchant1.state)
      end
      within("#merchant-#{@merchant2.id}") do
        expect(page).to have_content(@merchant2.name)
        expect(page).to have_content(@merchant2.city)
        expect(page).to have_content(@merchant2.state)
      end
      within("#merchant-#{@merchant3.id}") do
        expect(page).to have_content(@merchant3.name)
        expect(page).to have_content(@merchant3.city)
        expect(page).to have_content(@merchant3.state)
      end
    end
    
    it 'I see a list of merchants' do
      visit 'admin/merchants'
      click_link("#{@merchant1.name}")
      expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
    end

    it 'I see a button to disable a merchant' do
      visit '/admin/merchants'

      within("#merchant-#{@merchant1.id}") do
        click_button("Disable Merchant")
      end

      expect(current_path).to eq('/admin/merchants')

      expect(page).to have_content("Merchant #{@merchant1.name} Disabled")
      within("#merchant-#{@merchant1.id}") do
        expect(page).to have_button("Enable Merchant")
      end

      within("#merchant-#{@merchant2.id}") do
        expect(page).to have_button("Disable Merchant")
      end
    end

    it 'disabling a merchant also disables that merchants items' do
      visit '/admin/merchants'

      within("#merchant-#{@merchant1.id}") do
        click_button("Disable Merchant")
      end

      @merchant1.items.each do |item|
        expect(item.active?).to eq(false)
      end
    end

    it 'enabling a merchant also enables that merchants items' do
      visit '/admin/merchants'

      within("#merchant-#{@merchant3.id}") do
        click_button("Enable Merchant")
      end

      expect(page).to have_content("Merchant #{@merchant3.name} Enabled")

      @merchant3.items.each do |item|
        expect(item.active?).to eq(true)
      end
    end
  end
end
