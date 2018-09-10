require 'csv'

# CLEAN DATABASE

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

# USERS

user1 = User.create!(email: 'user@mail.com', password: 'aaaaaa')
user2 = User.create!(email: 'user2@mail.com', password: 'aaaaaa')

# JOURNEYS

journey1 = Journey.create!(
  user_id: user1.id,
  name: 'Hikking is my life',
  start_date: Date.today,
  end_date: Date.today,
  country: 'Portugal',
  city: 'Porto',
  photo: "https://picsum.photos/200/300?image=#{(1043..1057).to_a.sample}"
)

journey2 = Journey.create!(
  user_id: user1.id,
  name: 'Roadtripping',
  start_date: Date.today,
  end_date: Date.today,
  country: 'Spain',
  city: 'Santander',
  photo: "https://picsum.photos/200/300?image=#{(1043..1057).to_a.sample}"
)

journey3 = Journey.create!(
  user_id: user1.id,
  name: 'Holidays',
  start_date: Date.today,
  end_date: Date.today,
  country: 'Germany',
  city: 'Berlin',
  photo: "https://picsum.photos/200/300?image=#{(1043..1057).to_a.sample}"
)

# BAGS

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
  bag_id:     bag1.id,
  journey_id: journey1.id
)

packed_bag2 = PackedBag.create!(
  name:   'Little bag for the road',
  bag_id:     bag2.id,
  journey_id: journey2.id
)
