require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

    end

    it "I see all items in the system except disabled items and the item image is a link to that item's show page" do
      visit '/items'

      expect(page).to have_no_content(@dog_bone.name)
      expect(page).to have_no_content(@dog_bone.description)
      expect(page).to have_no_content("Price: $#{@dog_bone.price}")
      expect(page).to have_no_content("Inactive")
      expect(page).to have_no_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to have_no_css("img[src*='#{@dog_bone.image}']")

      find(:xpath, "//a[contains(@id,'image-#{@pull_toy.id}')]").click

      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end

    it "I see an area with statistics including the top 5 most popular items and 5 least popular" do
      merchant = create(:merchant)
      items = create_list(:item, 10, merchant: merchant)
      orders = create_list(:order, 10)
      create(:item_order, quantity: 10, item: items[0])
      create(:item_order, quantity: 15, item: items[1])
      create(:item_order, quantity: 20, item: items[2])
      create(:item_order, quantity: 25, item: items[3])
      create(:item_order, quantity: 26, item: items[4])
      create(:item_order, quantity: 1, item: items[5])
      create(:item_order, quantity: 13, item: items[6])
      create(:item_order, quantity: 30, item: items[6])
      create(:item_order, quantity: 40, item: items[8])
      create(:item_order, quantity: 100, item: items[9])
      create(:item_order, quantity: 200, item: items[7])

      visit '/items'

      within("#most-popular") do
        expect(page).to have_content("Most Popular 5 Items:")
        expect(page.all('li')[0]).to have_content(items[7].name)
        expect(page.all('li')[1]).to have_content(items[9].name)
        expect(page.all('li')[2]).to have_content(items[6].name)
        expect(page.all('li')[3]).to have_content(items[8].name)
        expect(page.all('li')[4]).to have_content(items[4].name)
      end

      within("#least-popular") do
        expect(page).to have_content("Least Popular 5 Items:")
        expect(page.all('li')[0]).to have_content(items[5].name)
        expect(page.all('li')[1]).to have_content(items[0].name)
        expect(page.all('li')[2]).to have_content(items[1].name)
        expect(page.all('li')[3]).to have_content(items[2].name)
        expect(page.all('li')[4]).to have_content(items[3].name)
      end
    end
  end
end
