require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    xit { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end
end
describe "class methods for Item" do
  before(:each) do
    merchant = create(:merchant)
    @items = create_list(:item, 10, merchant: merchant)
    orders = create_list(:order, 10)
    create(:item_order, quantity: 10, item: @items[0])
    create(:item_order, quantity: 15, item: @items[1])
    create(:item_order, quantity: 20, item: @items[2])
    create(:item_order, quantity: 25, item: @items[3])
    create(:item_order, quantity: 26, item: @items[4])
    create(:item_order, quantity: 1, item: @items[5])
    create(:item_order, quantity: 13, item: @items[6])
    create(:item_order, quantity: 30, item: @items[6])
    create(:item_order, quantity: 40, item: @items[8])
    create(:item_order, quantity: 100, item: @items[9])
    create(:item_order, quantity: 200, item: @items[7])
  end
  it ".most popular" do
    expect(Item.most_popular.length).to eq(5)
    expect(Item.most_popular.first.name).to eq(@items[7].name)
    expect(Item.most_popular.last.name).to eq(@items[4].name)
  end
  it ".least popular" do
    expect(Item.least_popular.length).to eq(5)
    expect(Item.least_popular.first.name).to eq(@items[5].name)
    expect(Item.least_popular.last.name).to eq(@items[3].name)
  end
end
