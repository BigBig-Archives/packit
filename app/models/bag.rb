class Bag < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :user
  has_many :packed_items, dependent: :destroy
  has_many :items, through: :packed_items
  has_many :references, through: :items

  # VALIDATIONS

  validates :name, presence: :true
  validates :capacity, presence: true, inclusion: {
    in: (5..120).to_a,
    message: "must be between 5 and 120 liters"
  }, allow_nil: false

  # METHODS

  def load_in_kilos
    return 0 if self.items.empty?
    self.items.map(&:weight).sum.round(1)
  end

  def load_in_liters
    return 0 if self.items.empty?
    self.items.map(&:size).sum.round(1)
  end

  def loaded
    return 0 if self.items.empty?
    (self.load_in_liters / self.capacity * 100).round(1)
  end

  def packed_items_count
    self.packed_items.count
  end

  def packed_reference_count(reference_to_count)
    self.references.select { |reference| reference == reference_to_count }.count
  end
end
