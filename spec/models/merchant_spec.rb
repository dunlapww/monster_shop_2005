require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
    it {should have_many(:orders).through(:item_orders)}
    it {should have_many(:item_orders).through(:items)}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      user = create(:user)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      user = create(:user)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to include("Denver")
      expect(@meg.distinct_cities).to include("Hershey")
    end


    it '#pending_orders' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      user = create(:user)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, status: "shipped")
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expected = [order_2, order_3]
      expect(@meg.pending_orders).to eq(expected)
    end

    it '#switch_items_active_status' do
      merchant3 = create(:merchant, active?: true)
      merchant4 = create(:merchant, active?: false)
      create(:item, merchant_id: merchant3.id, active?: false)
      create(:item, merchant_id: merchant3.id, active?: false)
      create(:item, merchant_id: merchant3.id, active?: false)
      create(:item, merchant_id: merchant4.id, active?: true)
      create(:item, merchant_id: merchant4.id, active?: true)
      create(:item, merchant_id: merchant4.id, active?: true)
      merchant3.switch_items_active_status
      merchant4.switch_items_active_status
      merchant3.items.each do |item|
        expect(item.active?).to eq(true)
      end

      merchant4.items.each do |item|
        expect(item.active?).to eq(false)
      end
    end

    it '#toggle_active_status' do
      @meg.toggle_active_status
      expect(@meg.active?).to eq(false)
      expect(@meg.items.first.active?).to eq(false)
      @meg.toggle_active_status
      expect(@meg.active?).to eq(true)
      expect(@meg.items.first.active?).to eq(true)
    end
  end
  describe 'class methods' do

    it 'not_disabled' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      john = Merchant.create(name: "john's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      not_expected = Merchant.create(name: "Disabled", address: '1', city: 'D', state: 'CO', zip: 80203, active?: false)
      expect(Merchant.not_disabled).to eq([meg,john])
    end
  end
end
