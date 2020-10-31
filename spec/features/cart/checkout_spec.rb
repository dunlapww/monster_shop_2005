require 'rails_helper'

feature 'Cart show' do
  describe 'When I have added items to my cart' do
    given!(:user) { create(:user, email_address: 'jack@daniels.com') }
    before(:each) do
      page.set_rack_session(user_id: user.id)
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end


    #User Story 26, Registered users can check out
    describe 'And I click the button or link to check out and fill out order info and click create order' do
      before(:each) do
        visit("/orders/new")
        fill_in :name, with: "Bob"
        fill_in "address", with: "Bob's address"
        fill_in "city", with: "Bob's city"
        fill_in "state", with: "Bob state"
        fill_in "zip", with: 808
      end
      describe 'An order is created in the system, which has a status of "pending"' do
        describe 'That order is associated with my user' do
          it 'I am here ("/profile/orders"), I see that my order is created, I see my that order in profile' do
            click_on 'Create Order'
            expect(current_path).to eq("/profile/orders/")
            expect(page).to have_content("Your order has been created!")
            within("#order-#{user.orders.last.id}") do
              expect(page).to have_link("order-#{user.orders.last.id}")
              expect(page).to have_content('pending')
            end
          end
          it 'My cart is now empty' do
            expect(page).to have_content('Cart: 3')
            click_on 'Create Order'
            expect(page).to have_content('Cart: 0')
          end
        end
      end
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
