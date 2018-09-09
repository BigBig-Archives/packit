class Item < ApplicationRecord
  belongs_to :user
  belongs_to :reference, class_name: 'ItemRef'

  def standard?
    self.custom_size.nil? && self.custom_weight.nil?
  end
end
