# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ItemOrder.destroy_all
Item.destroy_all
Order.destroy_all
Merchant.destroy_all
User.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
dark_helmet = bike_shop.items.create(name: "Dark Helmet", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
light_helmet = bike_shop.items.create(name: "Light Helmet", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 17)
blue_helmet = bike_shop.items.create(name: "Blue Helmet", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
squeaky_toy = dog_shop.items.create(name: "Squeaky Toy", description: "They'll love it!", price: 25, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 42)
chew_toy = dog_shop.items.create(name: "Chew Toy", description: "They'll love it!", price: 11, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 15)

#mike's items
paper = mike.items.create!(name: "Lined Paper",
  description: "Great for writing on!",
  price: 20,
  image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png",
  inventory: 25)

pencil = mike.items.create!(name: "Pencil",
  description: "Great for writing with!",
  price: 30,
  image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png",
  inventory: 2000)

#users
user1 = User.create!({password: "Bobpass",
                     name: "Bobname",
                     address: "Bobaddress",
                     city: "Bobcity",
                     state: "Bobstate",
                     zip: "Bobzip",
                     email_address: "Bobemail",
                     password_confirmation: "Bobpass",
                     role: 1})
user2 = User.create!({password: "Eugenepass",
                     name: "Eugenename",
                     address: "Eugeneaddress",
                     city: "Eugenecity",
                     state: "Eugenestate",
                     zip: "Eugenezip",
                     email_address: "Eugeneemail",
                     password_confirmation: "Eugenepass",
                     role: 1})
user3 = User.create!({password: "Connorpass",
                     name: "Connorname",
                     address: "Connoraddress",
                     city: "Connorcity",
                     state: "Connorstate",
                     zip: "Connorzip",
                     email_address: "Connoremail",
                     password_confirmation: "Connorpass",
                     role: 1})
user4 = User.create!({password: "Willpass",
                     name: "Willname",
                     address: "Willaddress",
                     city: "Willcity",
                     state: "Willstate",
                     zip: "Willzip",
                     email_address: "Willemail",
                     password_confirmation: "Willpass",
                     role: 1})
user5 = User.create!({password: "Jessepass",
                     name: "Jessename",
                     address: "Jesseaddress",
                     city: "Jessecity",
                     state: "Jessestate",
                     zip: "Jessezip",
                     email_address: "Jesseemail",
                     password_confirmation: "Jessepass",
                     role: 1})
user6 = User.create!({password: "Timpass",
                     name: "Timname",
                     address: "Timaddress",
                     city: "Timcity",
                     state: "Timstate",
                     zip: "Timzip",
                     email_address: "Timemail",
                     password_confirmation: "Timpass",
                     role: 1})

user1_order1 = user1.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)
user1_order2 = user1.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)
user2_order1 = user2.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)
user3_order1 = user3.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)
user4_order1 = user4.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)
user5_order1 = user5.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)
user6_order1 = user6.orders.create!(name: "Stuff",
                           address: "There",
                           city: "here",
                           state: "CO",
                           zip: 98798)

user1_order1.item_orders.create(item_id: tire.id, quantity: 5, price: tire.price)
user1_order1.item_orders.create(item_id: dark_helmet.id, quantity: 6, price: dark_helmet.price)
user1_order2.item_orders.create(item_id: light_helmet.id, quantity: 8, price: light_helmet.price)
user2_order1.item_orders.create(item_id: blue_helmet.id, quantity: 22, price: blue_helmet.price)
user3_order1.item_orders.create(item_id: pull_toy.id, quantity: 30, price: pull_toy.price)
user4_order1.item_orders.create(item_id: dog_bone.id, quantity: 25, price: dog_bone.price)
user5_order1.item_orders.create(item_id: squeaky_toy.id, quantity: 15, price: squeaky_toy.price)
user6_order1.item_orders.create(item_id: chew_toy.id, quantity: 7, price: chew_toy.price)
