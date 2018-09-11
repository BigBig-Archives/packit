class PackedItem < ApplicationRecord
  belongs_to :packed_bag
  belongs_to :item

  def name
    self.item.name
  end

  def weight
    self.item.weight
  end

  def size
    self.item.size
  end

  def catefory
    self.item.category
  end
end
