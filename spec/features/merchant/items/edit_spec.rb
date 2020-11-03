# As a merchant employee
# When I visit my items page
# And I click the edit button or link next to any item
# Then I am taken to a form similar to the 'new item' form
# The form is pre-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
# - name and description cannot be blank
# - price cannot be less than $0.00
# - inventory must be 0 or greater

require 'rails_helper'
feature 'As a merchant employee' do
  given!(:user) {@merchant_employee = create(:user, role:1)}

  describe 'When I visit my items page' do
    before :each do
      @merchant = create(:merchant)
      @merchant.users << @merchant_employee
      @merchant.items.create( :name => "Chamois Buttr",
                              :price => 18,
                              :description => "No more chaffin'!",
                              :image => "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg",
                              :inventory => 25)
      page.set_rack_session(user_id: @merchant_employee.id)

    end
    describe 'I see a button to edit item' do
      describe 'When I click on the button to add a new item' do
        it 'I see a form where I can add new information about an item and details, including:' do
          name = "Bob's Burgers"
          price = 3.50
          description = "Fantastic"
          image_url = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTQRW_dgJMiv7SHN9UxUpKAlyltLtLv_BKv7A&usqp=CAU"
          inventory = 20
          visit '/merchant/items'
          expect(page).to have_button('Edit Item')
          click_button('Edit Item')
          fill_in :Name, with: name
          fill_in :Price, with: price
          fill_in :Description, with: description
          fill_in :Image, with: image_url
          fill_in :Inventory, with: inventory
        end
      end
      describe 'When I submit valid information and submit the form' do
        it 'I am at items page, see a success flash, i se item, and image holder if left blank' do
          name = "Bob's Burgers"
          price = 3.50
          description = "Fantastic"
          image_url = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTQRW_dgJMiv7SHN9UxUpKAlyltLtLv_BKv7A&usqp=CAU"
          inventory = 20
          visit '/merchant/items'
          expect(page).to have_button('Edit Item')
          click_button('Edit Item')
          fill_in :Name, with: name
          fill_in :Price, with: price
          fill_in :Description, with: description
          fill_in :Image, with: image_url
          fill_in :Inventory, with: inventory
          click_button "Update Item"

          edited_item = Item.last

          expect(current_path).to eq("/merchant/items")
          expect(edited_item.name).to eq(name)
          expect(edited_item.price).to eq(price)
          expect(edited_item.description).to eq(description)
          expect(edited_item.image).to eq(image_url)
          expect(edited_item.inventory).to eq(inventory)
          expect(Item.last.active?).to be(true)
          expect("#item-#{Item.last.id}").to be_present
          expect(page).to have_content(name)
          expect(page).to have_content("Price: $#{edited_item.price}")
          expect(page).to have_css("img[src*='#{edited_item.image}']")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: #{edited_item.inventory}")
        end
      end
      describe 'I fill in partial attributes or restricted attributes' do
        before :each do
          @name = "Bob's Burgers"
          @price = 3.55
          @description = "Fantastic"
          @image_url = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTQRW_dgJMiv7SHN9UxUpKAlyltLtLv_BKv7A&usqp=CAU"
          @inventory = 20
          visit '/merchant/items'
          click_button('Edit Item')
        end
        it 'no name' do
          fill_in :Price, with: @price
          fill_in :Name, with: ""
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
          click_button "Update Item"
          expect(page).to have_content("Name can't be blank")
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
        end
        it 'no description' do
          fill_in :Name, with: @name
          fill_in :Description, with: ""
          fill_in :Price, with: @price
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
          click_button "Update Item"
          expect(page).to have_content("Description can't be blank")
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
        end
        it 'no picture' do
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Image, with: ""
          fill_in :Description, with: @description
          fill_in :Inventory, with: @inventory
          click_button "Update Item"
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
          fill_in :Name, with: @name
          fill_in :Price, with: 0
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
          click_button "Update Item"
          expect(page).to have_content("Price must be greater than 0")
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
        end
        it 'inventory = -1' do
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: -1
          click_button "Update Item"
          expect(page).to have_content("Inventory must be greater than or equal to 0")
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: @inventory
        end
        it 'has popluated fields after failure' do
          fill_in :Name, with: @name
          fill_in :Price, with: @price
          fill_in :Description, with: @description
          fill_in :Image, with: @image_url
          fill_in :Inventory, with: -1
          click_button "Update Item"
          expect(page).to have_field :Name, with: @name
          expect(page).to have_field :Price, with: "$#{@price}"
          expect(page).to have_field :Description, with: @description
          expect(page).to have_field :Image, with: @image_url
        end
      end
    end
  end
end


# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail
