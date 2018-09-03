class ItemCategory < ApplicationRecord
  has_many :item_refs, foreign_key: :category
end
