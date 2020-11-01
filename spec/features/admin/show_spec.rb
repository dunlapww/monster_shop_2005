require 'rails_helper'

# As an admin user
# When I visit my admin dashboard ("/admin")
# Then I see all orders in the system.
# For each order I see the following information:

# - user who placed the order, which links to admin view of user profile
# - order id
# - date the order was created

# Orders are sorted by "status" in this order:

# - packaged
# - pending
# - shipped
# - cancelled

feature 'admin show' do
  given!(:user) { create(:user, role: 2) }
  describe 'As an admin' do
    before :each do
      page.set_rack_session(user_id: user.id)
      @customer1 = create(:user)
      @customer2 = create(:user)
      create_list(:merchant, 2)
      @order1 = create(:order, user_id: @customer1.id)
      @order2 = create(:order, user_id: @customer2.id)
      create_list(:item_order, 5, order_id: @order1.id)
      create_list(:item_order, 5, order_id: @order2.id)
    end
    describe 'When I visit my show page: /admin' do
      it 'I see all orders in system and their details' do
        visit '/admin'
        Order.all.each do |order|
          within("#order-#{order.id}") do
            expect(page).to have_link(order.user.name)
            expect(page).to have_content("Order ID: #{order.id}")
            expect(page).to have_content("Created at: #{order.created_at.to_date}")
          end
        end
      end
      it 'displays all orders sorted by status: 1. packaged, 2. pending, 3. shipped, 4. cancelled' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
        
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
        customer = create(:user)
        order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: customer.id, status: 'packaged')
        order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: customer.id, status: 'shipped')
        order_3 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: customer.id, status: 'cancelled')
        order_4 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: customer.id, status: 'pending')
        
        visit "/admin"
        
        within("#orders") do
          expect(page.all('li')[0]).to have_content("#{order_1.id}") #packaged
          expect(page.all('li')[1]).to have_content("#{@order1.id}") #pending
          expect(page.all('li')[2]).to have_content("#{@order2.id}") #pending
          expect(page.all('li')[3]).to have_content("#{order_4.id}") #pending
          expect(page.all('li')[4]).to have_content("#{order_2.id}") #shipped
          expect(page.all('li')[5]).to have_content("#{order_3.id}") #cancelled
        end
        
      end
    end
  end
end
