class ItemRef < ApplicationRecord
  belongs_to :category, class_name: 'ItemCategory'
  has_many :packed_items, dependent: :destroy

  def count_owned(user)
    self.packed_items.select { |packed_item| packed_item.packed_bag.user == user }.count
  end
end
