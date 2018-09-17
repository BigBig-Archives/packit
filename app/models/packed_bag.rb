class PackedBag < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :bag
  belongs_to :journey
  has_many :packed_items, dependent: :destroy
  has_many :items, through: :packed_items
  has_many :references, through: :items

  # VALIDATIONS

  validates :name, presence: :true

  # METHODS

  def user
    self.bag.user
  end

  def capacity
    self.bag.capacity
  end

  def picture
    self.bag.picture
  end

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
