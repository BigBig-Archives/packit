# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# CLEAN DATABASE

JourneyBag.destroy_all
Journey.destroy_all
PackedItem.destroy_all
PackedBag.destroy_all
Item.destroy_all
ItemRef.destroy_all
ItemCategory.destroy_all
Bag.destroy_all
BagRef.destroy_all
BagCategory.destroy_all
User.destroy_all

# USERS

user = User.create!(email: 'user@mail.com', password: 'aaaaaa')
user2 = User.create!(email: 'user2@mail.com', password: 'aaaaaa')
user3 = User.create!(email: 'user3@mail.com', password: 'aaaaaa')

# ITEMS

clothes = ItemCategory.create!(name: 'clothes')
10.times do |i|
  ItemRef.create!(
    name: Faker::Zelda.item,
    category_id: clothes.id,
    size: 1,
    weight: 1,
    picture: "item_#{i + 1}"
  )
end
# img / 21

hygiene = ItemCategory.create!(name: 'hygiene')
8.times do |i|
  ItemRef.create!(
    name: Faker::Dessert.topping,
    category_id: hygiene.id,
    size: 1,
    weight: 1,
    picture: "item_#{i + 1 + 10}"
  )
end
# img / 13

hobbies = ItemCategory.create!(name: 'hobbies')
13.times do |i|
  ItemRef.create!(
    name: Faker::Food.vegetables,
    category_id: hobbies.id,
    size: 1,
    weight: 1,
    picture: "item_#{i + 1 + 10 + 8}"
  )
end
# img / 0

ItemCategory.create!(name: 'bedding')
ItemCategory.create!(name: 'papers')
ItemCategory.create!(name: 'tools')
