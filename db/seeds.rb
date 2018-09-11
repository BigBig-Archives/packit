require 'csv'

# CLEAN DATABASE

Journey.destroy_all
PackedItem.destroy_all
PackedBag.destroy_all
Item.destroy_all
ItemReference.destroy_all
ItemCategory.destroy_all
Bag.destroy_all
BagTemplate.destroy_all
User.destroy_all

# USERS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  User.create!(
    email:      row['email'],
    password:   row['password'],
    username:   row['username'],
    first_name: row['first_name'],
    last_name:  row['last_name'],
    photo:      row['photo']
  )
end

# ITEM CATEGORIES

csv_text = File.read(Rails.root.join('lib', 'seeds', 'item_categories.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  ItemCategory.create!(
    name:    row['name'],
    picture: row['picture'],
  )
end

# ITEM REFERENCES

csv_text = File.read(Rails.root.join('lib', 'seeds', 'item_references.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  ItemReference.create!(
    name:        row['name'],
    size:        row['size'],
    weight:      row['weight'],
    picture:     row['picture'],
    category_id: ItemCategory.where(name: row['category']).first.id
  )
end

# ITEMS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'items.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  Item.create!(
    user_id:      User.where(username: row['user']).first.id,
    reference_id: ItemReference.where(name: row['reference']).first.id,
    size:         row['size'],
    weight:       row['weight'],
    picture:      row['picture'],
    commentary:      row['commentary'],
  )
end

# BAG TEMPLATES

csv_text = File.read(Rails.root.join('lib', 'seeds', 'bag_templates.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  BagTemplate.create!(
    name:     row['name'],
    capacity: row['capacity'],
    picture:  row['picture']
  )
end

# BAGS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'bags.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  Bag.create!(
    user_id:  User.where(username: row['user']).first.id,
    name:     row['name'],
    capacity: row['capacity'],
    picture:  row['picture']
  )
end

# JOURNEYS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'journeys.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  Journey.create!(
    user_id:    User.where(username: row['user']).first.id,
    name:       row['name'],
    start_date: Date.today,
    end_date:   Date.today,
    photo:      row['photo'],
    location:   row['location']
  )
end

# PACKED BAGS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'packed_bags.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  PackedBag.create!(
    bag_id:     Bag.where(name: row['bag']).first.id,
    journey_id: Journey.where(name: row['journey']).first.id
  )
end

# PACKED ITEMS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'packed_items.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  PackedItem.create!(
    packed_bag_id: PackedBag.joins(:bag).where(bags: { name: row['packed_bag'] }).first.id,
    item_id:       Item.where(commentary: row['item']).first.id
  )
end
