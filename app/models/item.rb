class Item < ApplicationRecord
  belongs_to :user
  belongs_to :reference, class_name: 'ItemReference'
  has_many :packed_items, dependent: :destroy

  before_create :set_size, :set_weight

  validates :size, presence: true, inclusion: {
    in: (0..10_000).to_a,
    message: "Size should be between 0 and 10 000 ml"
  }, allow_nil: true

  validates :weight, presence: true, inclusion: {
    in: (0..20_000).to_a,
    message: "Size should be between 0 and 20 000 mg"
  }, allow_nil: true

  def name
    self.reference.name
  end

  def category
    self.reference.category
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
