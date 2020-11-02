require 'rails_helper'

feature 'Merchant employee merchant index' do
  given!(:user) {@merchant_employee = create(:user, role: 1)}
  describe 'When I visit the merchant index page' do
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
      @item4 = create(:item, merchant_id: @merchant1.id, active?: false)
      @item5 = create(:item, merchant_id: @merchant1.id, active?: false)
      @item6 = create(:item, merchant_id: @merchant1.id, active?: false)
    end
    describe 'When I visit items page' do
      it 'I see all my items and their details [name, description, imgae, active?, inventory] and button to deactivate' do
        visit "/merchant/items"
        within "#item-#{@item1.id}" do
          expect(page).to have_content(@item1.name)
          expect(page).to have_content(@item1.description)
          expect(page).to have_content("#{@item1.price.round(2)}")
          expect(page).to have_content(@item1.active?)
          expect(page).to have_content(@item1.inventory)
          expect(page).to have_button("Deactivate")

        end

        within "#item-#{@item2.id}" do
          expect(page).to have_content(@item2.name)
          expect(page).to have_content(@item2.description)
          expect(page).to have_content("#{@item2.price.round(2)}")
          expect(page).to have_content(@item2.active?)
          expect(page).to have_content(@item2.inventory)
          expect(page).to have_button("Deactivate")
        end

        within "#item-#{@item3.id}" do
          expect(page).to have_content(@item3.name)
          expect(page).to have_content(@item3.description)
          expect(page).to have_content("#{@item3.price.round(2)}")
          expect(page).to have_content(@item3.active?)
          expect(page).to have_content(@item3.inventory)
          expect(page).to have_button("Deactivate")
        end

      end
    end
  end
end
