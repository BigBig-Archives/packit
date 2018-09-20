class Item < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :user
  belongs_to :reference, class_name: 'ItemReference'
  has_many :packed_items, dependent: :destroy

  # SCOPES

  scope :category, -> (category, user) {
    joins(:reference)
    .where(item_references: { category_id: category })
    .joins(:user)
    .where(users: { id: user })
    .order(created_at: :desc)
  }
  scope :packed, -> (bag) {
    joins(:packed_items)
    .where(packed_items: { bag_id: bag })
  }

  # VALIDATIONS

  validates :size, numericality: { greater_than: 0, less_than_or_equal_to: 99.9 }
  validates :weight, numericality: { greater_than: 0, less_than_or_equal_to: 99.9 }

  # CALLBACKS

  before_create :set_size, :set_weight

  # METHODS

  def name
    self.reference.name
  end

  def category
    self.reference.category
  end

  def picture
    self.reference.picture
  end

  def packed?(bag)
    self.packed_items.where(bag: bag).any?
  end

  private

  def set_size
    self.size = self.size.round(1)
  end

  def set_weight
    self.weight = self.weight.round(1)
  end
end
