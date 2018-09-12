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
  scope :packed, -> (packed_bag) {
    joins(:packed_items)
    .where(packed_items: { packed_bag_id: packed_bag })
  }

  # VALIDATIONS

  validates :size, presence: true, inclusion: { in: (0..10_000).to_a, message: "should be between 0 and 10 000ml" }, allow_nil: true
  validates :weight, presence: true, inclusion: { in: (0..20_000).to_a, message: "should be between 0 and 20 000g" }, allow_nil: true

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

  def packed?(packed_bag)
    self.packed_items.where(packed_bag: packed_bag).any?
  end

  private

  def set_size
    self.size = self.reference.size if self.size.nil?
  end

  def set_weight
    self.weight = self.reference.weight if self.weight.nil?
  end
end
