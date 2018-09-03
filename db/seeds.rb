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
Category.destroy_all
Bag.destroy_all
BagRef.destroy_all
User.destroy_all

# USERS

user = User.create!(
  email: 'user@mail.com',
  password: 'aaaaaa'
)

# ITEMS

clothes = Category.create!(
  name: 'clothes'
)

  sweater = ItemRef.create!(
    name: 'sweater',
    category_id: clothes.id,
    size: 1,
    weight: 1,
    picture: 'url'
  )

  hat = ItemRef.create!(
    name: 'hat',
    category_id: clothes.id,
    size: 1,
    weight: 1,
    picture: 'url'
  )

hygiene = Category.create!(
  name: 'hygiene'
)

  toothbrush = ItemRef.create!(
    name: 'toothbrush',
    category_id: hygiene.id,
    size: 1,
    weight: 1,
    picture: 'url'
  )

  hairdryer = ItemRef.create!(
    name: 'hairdryer',
    category_id: hygiene.id,
    size: 1,
    weight: 1,
    picture: 'url'
  )

hobbies = Category.create!(
  name: 'hobbies'
)

  book = ItemRef.create!(
    name: 'book',
    category_id: hobbies.id,
    size: 1,
    weight: 1,
    picture: 'url'
  )

