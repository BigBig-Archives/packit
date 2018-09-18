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
    password:   row['password'],
    username:   row['username']
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

unless references_only
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
end

# BAGS

unless references_only
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
end

# PACKED ITEMS

unless references_only
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'packed_items.csv'))
  csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
  csv.each do |row|
    PackedItem.create!(
      bag_id:  Bag.where(bags: { name: row['bag'] }).first.id,
      item_id: Item.where(commentary: row['item']).first.id
    )
  end
end
