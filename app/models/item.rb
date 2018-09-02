class Item < ApplicationRecord
  belongs_to :user
  belongs_to :item_ref

  def standard?
    self.custom_size.nil? && self.custom_weight.nil?
  end

  def true?
    true
  end
end
