#User Story 45, Merchant adds an item
require 'rails_helper'
feature 'As a merchant employee' do
  given!(:user) {@merchant_employee = create(:user, role:1)}

  describe 'When I visit my items page' do
    before :each do
      @merchant = create(:merchant)
      @merchant.users << @merchant_employee
      page.set_rack_session(user_id: @merchant_employee.id)

    end
    describe 'I see a link to add a new item' do
      describe 'When I click on the link to add a new item' do
        it 'I see a form where I can add new information about an item and details, including:' do
          name = "Chamois Buttr"
          price = 18
          description = "No more chaffin'!"
          image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
          inventory = 25
          visit '/merchant/items'
          expect(page).to have_link('Add New Item')
          click_link('Add New Item')
          fill_in :name, with: name
          fill_in :price, with: price
          fill_in :description, with: description
          fill_in :image, with: image_url
          fill_in :inventory, with: inventory
        end
      end
      describe 'When I submit valid information and submit the form' do
        it 'I am at items page, see a success flash, i se item, and image holder if left blank' do
          name = "Chamois Buttr"
          price = 18
          description = "No more chaffin'!"
          image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
          inventory = 25
          visit '/merchant/items'
          click_link('Add New Item')
          fill_in :name, with: name
          fill_in :price, with: price
          fill_in :description, with: description
          fill_in :image, with: image_url
          fill_in :inventory, with: inventory
          click_button "Create Item"

          new_item = Item.last

          expect(current_path).to eq("/merchant/items")
          expect(new_item.name).to eq(name)
          expect(new_item.price).to eq(price)
          expect(new_item.description).to eq(description)
          expect(new_item.image).to eq(image_url)
          expect(new_item.inventory).to eq(inventory)
          expect(Item.last.active?).to be(true)
          expect("#item-#{Item.last.id}").to be_present
          expect(page).to have_content(name)
          expect(page).to have_content("Price: $#{new_item.price}")
          expect(page).to have_css("img[src*='#{new_item.image}']")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: #{new_item.inventory}")
        end
      end
      describe 'I fill in partial attributes or restricted attributes' do
        before :each do
          @name = "Chamois Buttr"
          @price = 18
          @description = "No more chaffin'!"
          @image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
          @inventory = 25
          visit '/merchant/items'
          click_link('Add New Item')
        end
        it 'no name' do
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
          click_button "Create Item"
          expect(page).to have_content("Name can't be blank")
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
        end
        it 'no description' do
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
          click_button "Create Item"
          expect(page).to have_content("Description can't be blank")
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
        end
        it 'no picture' do
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :inventory, with: @inventory
          click_button "Create Item"
          new_item = Item.last
          expect(current_path).to eq("/merchant/items")
          expect(new_item.name).to eq(@name)
          expect(new_item.price).to eq(@price)
          expect(new_item.description).to eq(@description)
          expect(new_item.image).to eq('https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png')
          expect(new_item.inventory).to eq(@inventory)
          expect(Item.last.active?).to be(true)
          expect("#item-#{Item.last.id}").to be_present
          expect(page).to have_content(@name)
          expect(page).to have_content("Price: $#{new_item.price}")
          expect(page).to have_css("img[src*='#{new_item.image}']")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: #{new_item.inventory}")
        end
        it 'Price = 0' do
          fill_in :name, with: @name
          fill_in :price, with: 0
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
          click_button "Create Item"
          expect(page).to have_content("Price must be greater than 0")
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
        end
        it 'inventory = -1' do
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: -1
          click_button "Create Item"
          expect(page).to have_content("Inventory must be greater than or equal to 0")
          fill_in :name, with: @name
          fill_in :price, with: @price
          fill_in :description, with: @description
          fill_in :image, with: @image_url
          fill_in :inventory, with: @inventory
        end
      end
    end
  end
end
