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
    message: "should be between 5 and 120 liters"
  }, allow_nil: false

  # METHODS

  def load_in_kilos
    self.packed_items.map(&:weight).sum.round(2)
  end

  def load_in_liters
    self.packed_items.map(&:size).sum.round(2)
  end

  def loaded
    (self.load_in_liters / self.capacity).round(2)
  end

  def packed_reference_count(reference_to_count)
    self.references.select { |reference| reference == reference_to_count }.count
  end
end
