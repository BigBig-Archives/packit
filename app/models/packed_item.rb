class PackedItem < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :bag
  belongs_to :item

  # SCOPES

  scope :packed, -> (category, bag) {
    joins(item: [:reference])
    .joins(:bag)
    .where(item_references: { category_id: category })
    .where(bag: bag)
    .order(created_at: :desc)
  }

  # VALIDATIONS

  validates :item, uniqueness: { scope: :bag, message: "should not be already packed" }

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
