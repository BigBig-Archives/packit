require 'csv'

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

user1 = User.create!(email: 'user@mail.com', password: 'aaaaaa')
user2 = User.create!(email: 'user2@mail.com', password: 'aaaaaa')

# ITEM_REFS

tools         = ItemCategory.create!(name: 'tools', picture: 'tools')
food          = ItemCategory.create!(name: 'food', picture: 'food')
clothes       = ItemCategory.create!(name: 'clothes', picture: 'clothes')
bedtime       = ItemCategory.create!(name: 'bedtime', picture: 'bedtime')
sport         = ItemCategory.create!(name: 'sport', picture: 'sport')
hobbies       = ItemCategory.create!(name: 'hobbies', picture: 'hobbies')
miscellaneous = ItemCategory.create!(name: 'miscellaneous', picture: 'miscellaneous')

csv_text = File.read(Rails.root.join('lib', 'seeds', 'items.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  ItemRef.create!(
    name:        row['name'],
    size:        row['size'],
    weight:      row['weight'],
    picture:     row['picture'],
    category_id: ItemCategory.where(name: row['category']).first.id
  )
end

# BAG_REFS

BagCategory.create(name: 'hiking')

csv_text = File.read(Rails.root.join('lib', 'seeds', 'bags.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  BagRef.create!(
    category_id: BagCategory.first.id,
    name:        row['name'],
    capacity:    row['capacity'],
    picture:     row['picture']
  )
end

bag1 = Bag.create!(
  user_id:      user1.id,
  reference_id: BagRef.where(name: "backpack 60'").first.id
)

bag2 = Bag.create!(
  user_id:      user1.id,
  reference_id: BagRef.where(name: "basket 30'").first.id
)

# PACKED_BAGS

packed_bag1 = PackedBag.create!(
  name:   'Best packed bag',
  bag_id: bag1.id
)

# PACKED_ITEMS

sunglasses = Item.create!(
  user_id:      user1.id,
  reference_id: ItemRef.where(name: 'sunglasses').first.id
)

preserve1 = Item.create!(
  user_id:      user1.id,
  reference_id: ItemRef.where(name: 'preserve').first.id
)

preserve2 = Item.create!(
  user_id:      user1.id,
  reference_id: ItemRef.where(name: 'preserve').first.id
)

PackedItem.create!(
  packed_bag_id: packed_bag1.id,
  item_id: sunglasses.id,
)

PackedItem.create!(
  packed_bag_id: packed_bag1.id,
  item_id: preserve1.id,
)

PackedItem.create!(
  packed_bag_id: packed_bag1.id,
  item_id: preserve2.id,
)
