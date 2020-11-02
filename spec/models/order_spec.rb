require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      user = create(:user)
      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      @io_pulltoy = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @io_tire = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'status' do
      expect(@order_1.status).to eq('pending')
    end

    it 'quantity_of_items' do
      expect(@order_1.quantity_of_items).to eq(2)
    end

    it '#merchant_items_qty' do
      @item3 = create(:item, merchant_id: @meg.id)
      @order_1.item_orders.create!(item: @item3, price: @item3.price, quantity: 5)
      
      expect(@order_1.merchant_items_qty(@meg.id)).to eq(7)
    end

    it '#merchant_items_value' do
      @item3 = create(:item, merchant_id: @meg.id, price: 10)
      @io_item3 = @order_1.item_orders.create!(item: @item3, price: @item3.price, quantity: 5)
      expect(@order_1.merchant_items_value(@meg.id)).to eq(@tire.price * @io_tire.quantity + @item3.price * @io_item3.quantity)
    end
    
    it '#can_be_cancelled?' do
      order2 = create(:order, status: 'shipped')
      order3 = create(:order, status: 'packaged')
      order4 = create(:order, status: 'cancelled')
      expect(@order_1.can_be_cancelled?).to eq(true)
      expect(order2.can_be_cancelled?).to eq(false)
      expect(order3.can_be_cancelled?).to eq(true)
      expect(order4.can_be_cancelled?).to eq(false)
    end

    describe "When all items in an order have been 'fulfilled' by their merchants" do
      it 'order status changes from pending to packaged' do
        expect(@order_1.status).to eq("pending")
        @order_1.item_orders.each do |item_order|
          item_order.update(status: "fulfilled")
        end
        @order_1.package
        expect(@order_1.status).to eq("packaged")
      end
    end
  end

  describe 'class methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      user = create(:user)
      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, status: 'packaged')
      @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, status: 'shipped')
      @order_3 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, status: 'cancelled')
      @order_4 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, status: 'pending')

    end
    it 'can sort orders by status: 1. packaged, 2. pending, 3. shipped, 4. cancelled' do
      expected = [@order_1, @order_4, @order_2, @order_3]
      expect(Order.status_sort).to eq(expected)
    end
  end
end
