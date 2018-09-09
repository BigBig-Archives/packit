class PackedBag < ApplicationRecord
  belongs_to :bag
  has_many :packed_items

  def user
    self.bag.user
  end
end
