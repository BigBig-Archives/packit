class PackedBag < ApplicationRecord
  belongs_to :bag
  has_many :packed_items, dependent: :destroy

  def user
    self.bag.user
  end
end
