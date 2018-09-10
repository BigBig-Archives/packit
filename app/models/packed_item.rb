class PackedItem < ApplicationRecord
  belongs_to :packed_bag
  belongs_to :item_ref
end
