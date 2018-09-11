class ItemCategory < ApplicationRecord

  # ASSOCIATIONS

  has_many :references, class_name: 'ItemReference', foreign_key: :category, dependent: :destroy

end
