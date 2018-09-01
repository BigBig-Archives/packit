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
UserItem.destroy_all
Item.destroy_all
UserBag.destroy_all
Bag.destroy_all
User.destroy_all

# USERS

user = User.create!(
  email: 'user@mail.com',
  password: 'azeqsd'
)

# BAGS

suitcase = Bag.create!(
  name: 'suitcase',
  category: 1,
  size: 1,
  capacity: 1,
  weight: 1
)

rucksack = Bag.create!(
  name: 'rucksack',
  category: 2,
  size: 1,
  capacity: 1,
  weight: 1
)

user_suitcase = UserBag.create!(
  user_id: user.id,
  bag_id: suitcase.id,
  custom_size: 2,
  custom_capacity: 1,
  custom_weight: 3,
)

user_rucksack = UserBag.create!(
  user_id: user.id,
  bag_id: rucksack.id,
  custom_size: 2,
  custom_capacity: 1,
  custom_weight: 3,
)

# ITEMS

sweater = Item.create!(
  name: 'sweater',
  category: 1,
  size: 1,
  weight: 1,
  picture: 'url'
)

book = Item.create!(
  name: 'book',
  category: 3,
  size: 1,
  weight: 1,
  picture: 'url'
)

user_sweater = UserItem.create!(
  user_id: user.id,
  item_id: sweater.id,
  commentary: 'comment',
  custom_size: 1,
  custom_weight: 1,
  photo: 'url'
)

user_book = UserItem.create!(
  user_id: user.id,
  item_id: book.id,
  commentary: 'comment',
  custom_size: 1,
  custom_weight: 1,
  photo: 'url'
)

# PACKED BAGS AND ITEMS

packed_suitcase = PackedBag.create!(
  user_bag_id: user_suitcase.id,
  custom_load: 1,
  custom_weight: 1
)

packed_rucksack = PackedBag.create!(
  user_bag_id: UserBag.first.id,
  custom_load: 1,
  custom_weight: 1
)

sweater_to_suitcase = PackedItem.create!(
  user_item_id: book.id,
  packed_bag_id: packed_suitcase.id
)

sweater_to_rucksack = PackedItem.create!(
  user_item_id: sweater.id,
  packed_bag_id: packed_rucksack.id
)

# JOURNEYS

journey = Journey.create!(
  user_id: user.id,
  name: 'Portugal',
  start_date: Date.today + 2.days,
  end_date: Date.today + 5.days,
  category: 1,
  country: 'Portugal',
  city: 'Porto',
  photo: 'url'
)

journey_suitcase = JourneyBag.create!(
  journey_id: journey.id,
  packed_bag_id: packed_suitcase.id
)

journey_rucksack = JourneyBag.create!(
  journey_id: journey.id,
  packed_bag_id: packed_rucksack.id
)
