class PackedItem < ApplicationRecord
  belongs_to :packed_bag
  belongs_to :item_ref

  def weight
    self.item_ref.weight
  end

  def size
    self.item_ref.size
  end
end
