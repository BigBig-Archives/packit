class ItemRef < ApplicationRecord
  belongs_to :category, class_name: 'ItemCategory'
  has_many :items, foreign_key: :reference
end
