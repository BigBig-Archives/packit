class Bag < ApplicationRecord
  belongs_to :user
  belongs_to :reference, class_name: 'BagRef'
end
