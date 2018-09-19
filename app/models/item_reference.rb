class ItemReference < ApplicationRecord
  # ASSOCIATIONS

  belongs_to :category, class_name: 'ItemCategory'
  has_many :items, foreign_key: :reference
  has_many :packed_items, through: :items
  has_many :bags, through: :packed_items

  # METHODS

  def count_owned(user)
    self.items.select { |item| item.user == user }.count
  end

  def unpacked_items(user, bag)
    items = self.items.select { |item| item.user == user }
    packed_items = self.packed_items.select { |packed_item| packed_item.bag == bag }
    items_already_packed = packed_items.map { |packed| packed.item }
    unpacked = items - items_already_packed
  end
end
