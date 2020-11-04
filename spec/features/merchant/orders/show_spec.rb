require 'rails_helper'

# As a merchant employee
# When I visit an order show page from my dashboard
# I see the recipients name and address that was used to create this order
# I only see the items in the order that are being purchased from my merchant
# I do not see any items in the order being purchased from other merchants
# For each item, I see the following information:
# - the name of the item, which is a link to my item's show page
# - an image of the item
# - my price for the item
# - the quantity the user wants to purchase

feature "As a merchant employee" do
  given!(:user){@merchant_employee = create(:user, role: 1)}
  before :each do
    page.set_rack_session(user_id: @merchant_employee.id)
    
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant1.users << @merchant_employee
    @customer1 = create(:user)
    @order1 = create(:order, user_id: @customer1.id)
    @item1 = create(:item, merchant_id: @merchant1.id)
    @item2 = create(:item, merchant_id: @merchant1.id)
    @item3 = create(:item, merchant_id: @merchant2.id)
    @io1 = create(:item_order, order_id: @order1.id, item_id: @item1.id)
    @io2 = create(:item_order, order_id: @order1.id, item_id: @item2.id)
    @io3 = create(:item_order, order_id: @order1.id, item_id: @item3.id)
  end
  describe "When I visit an order show page" do
    it "I see the recipients name and address that was used to create this order" do
      visit "/merchant/orders/#{@order1.id}"
      expect(page).to have_content("#{@order1.user.name}")
      expect(page).to have_content("#{@order1.user.address}")
      expect(page).to have_content("#{@order1.user.city}")
      expect(page).to have_content("#{@order1.user.state}")
      expect(page).to have_content("#{@order1.user.zip}")
    end

    it "I only see the items in the order that are being purchased from my merchant" do
      visit "/merchant/orders/#{@order1.id}"
       within("#io-#{@io1.id}") do
        expect(page).to have_link("#{@item1.name}")
        expect(page).to have_content("#{@item1.image}")
        expect(page).to have_content("#{@item1.price.round(2)}")
        expect(page).to have_content("#{@io1.quantity}")
       end
       within("#io-#{@io2.id}") do
        expect(page).to have_link("#{@item2.name}")
        expect(page).to have_content("#{@item2.image}")
        expect(page).to have_content("#{@item2.price.round(2)}")
        expect(page).to have_content("#{@io2.quantity}")
       end
       expect(page).to_not have_selector("#io-#{@io3.id}")
    end
    it "when I click on an item link, I'm directed to the item's show page" do
      visit "/merchant/orders/#{@order1.id}"
      within("#io-#{@io1.id}") do
        click_link("#{@item1.name}")
      end
      expect(current_path).to eq("/items/#{@io1.item.id}")
    end
  end
end
