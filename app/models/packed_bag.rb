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

  def weight
    self.packed_items.map(&:weight).sum
  end

  def load
    self.packed_items.map(&:size).sum
  end

  def loaded
    (self.load / self.capacity.to_f).round(2)
  end

  def packed_reference_count(reference_to_count)
    self.references.select { |reference| reference == reference_to_count }.count
  end
end
