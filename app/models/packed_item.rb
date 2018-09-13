class PackedItem < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :packed_bag
  belongs_to :item

  # SCOPES

  scope :packed, -> (category, packed_bag) {
    joins(item: [:reference])
    .joins(:packed_bag)
    .where(item_references: { category_id: category })
    .where(packed_bag: packed_bag)
    .order(created_at: :desc)
  }

  # VALIDATIONS

  validates :item, uniqueness: { scope: :packed_bag, message: "should not be already packed" }

  # METHODS

  def name
    self.item.name
  end

  def weight
    self.item.weight
  end

  def size
    self.item.size
  end

  def catefory
    self.item.category
  end

  def picture
    self.item.picture
  end
end
