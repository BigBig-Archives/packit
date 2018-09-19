require 'csv'

# CONFIG

references_only = true


# CLEAN DATABASE

PackedItem.destroy_all
Item.destroy_all
ItemReference.destroy_all
ItemCategory.destroy_all
Bag.destroy_all
User.destroy_all

# USERS

csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  User.create!(
    email:      row['email'],
    password:   row['password']
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
