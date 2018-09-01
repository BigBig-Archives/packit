class PackedBag < ApplicationRecord
  belongs_to :user_bag
  has_many :packed_items
end
