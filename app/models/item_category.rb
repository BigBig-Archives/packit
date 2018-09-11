class ItemCategory < ApplicationRecord
  has_many :references, class_name: 'ItemReference', foreign_key: :category, dependent: :destroy
end
