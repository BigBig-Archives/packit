class PackedBag < ApplicationRecord
  belongs_to :bag
  belongs_to :journey
  has_many :packed_items, dependent: :destroy

  def name
    "#{self.bag.name} - #{self.journey.name}"
  end

  def user
    self.bag.user
  end

  def capacity
    self.bag.capacity
  end
end
