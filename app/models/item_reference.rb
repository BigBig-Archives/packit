class ItemReference < ApplicationRecord
  belongs_to :category, class_name: 'ItemCategory'
  has_many :items, foreign_key: :reference

  def count_owned(user)
    self.items.select { |item| item.user == user }.count
  end
end
