class ItemReference < ApplicationRecord
  # ASSOCIATIONS

  belongs_to :category, class_name: 'ItemCategory'
  has_many :items, foreign_key: :reference
  has_many :packed_items, through: :items
  has_many :packed_bags, through: :packed_items

  # SCOPES

  scope :category, -> (category, user) {
    joins(:item)
    .where(item_references: { category_id: category })
    .joins(:user)
    .where(users: { id: user })
    .order(created_at: :desc)
  }

  # METHODS

  def count_owned(user)
    self.items.select { |item| item.user == user }.count
  end
end
