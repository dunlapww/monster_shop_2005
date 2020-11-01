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

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
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

    it 'cancel_order' do
      item = create(:item)
      item2 = create(:item)
      order_item = create(:item_order, order: @order_1, item: item)
      order_item2 = create(:item_order, order: @order_1, item: item2)
      @order_1.cancel_order
      expect(@order_1.item_orders.pluck(:status).all?('unfulfilled')).to eq(true)
    end

    it 'fullilled?' do
      user = create(:user)
      user.orders << @order_1
      expect(user.orders.first.fulfilled?).to eq(false)
      user.orders.first.item_orders.first.update(status: 'fulfilled')
      expect(user.orders.first.fulfilled?).to eq(false)
      user.orders.first.item_orders.last.update(status: 'fulfilled')
      expect(user.orders.first.fulfilled?).to eq(true)
    end
  end
end
