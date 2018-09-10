class BagRef < ApplicationRecord
  belongs_to :category, class_name: 'BagCategory'
  has_many :bags, foreign_key: :reference, dependent: :destroy
end
