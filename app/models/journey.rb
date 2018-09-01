class Journey < ApplicationRecord
  belongs_to :user
  has_many :journey_bags
end
