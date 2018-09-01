class Bag < ApplicationRecord
  belongs_to :user
  belongs_to :bag_ref
end
