class ItemCategory < ApplicationRecord
  has_many :references, class_name: 'ItemRef', foreign_key: :category
end
