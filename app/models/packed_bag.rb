class PackedBag < ApplicationRecord
  belongs_to :bag
  has_many :packed_items
end
