class PackedItem < ApplicationRecord
  belongs_to :packed_bag
  belongs_to :user_item
end
