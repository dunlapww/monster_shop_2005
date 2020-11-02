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

        within "#item-#{@item4.id}" do
          expect(page).to have_content(@item4.name)
          expect(page).to have_content(@item4.description)
          expect(page).to have_content("#{@item4.price.round(2)}")
          expect(page).to have_content(@item4.active?)
          expect(page).to have_content(@item4.inventory)
          expect(page).to have_button("Activate")
        end

        within "#item-#{@item5.id}" do
          expect(page).to have_content(@item5.name)
          expect(page).to have_content(@item5.description)
          expect(page).to have_content("#{@item5.price.round(2)}")
          expect(page).to have_content(@item5.active?)
          expect(page).to have_content(@item5.inventory)
          expect(page).to have_button("Activate")
        end

        within "#item-#{@item6.id}" do
          expect(page).to have_content(@item6.name)
          expect(page).to have_content(@item6.description)
          expect(page).to have_content("#{@item6.price.round(2)}")
          expect(page).to have_content(@item6.active?)
          expect(page).to have_content(@item6.inventory)
          expect(page).to have_button("Activate")
        end
      end

      it 'when I click button to activate or deactivate, I am in index and see the item has been toggled with notification' do
        visit "/merchant/items"

        within "#item-#{@item1.id}" do
          click_button("Deactivate")
          expect(page).to have_content("false")
        end
        expect(page).to have_content("#{@item1.name} is no longer available for sale")

        within "#item-#{@item5.id}" do
          click_button("Activate")
          expect(page).to have_content("true")
        end
        expect(page).to have_content("#{@item5.name} is now available for sale")

      end
    end
  end
end
