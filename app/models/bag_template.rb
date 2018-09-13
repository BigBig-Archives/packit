class BagTemplate < ApplicationRecord
  validates :capacity, presence: true, inclusion: {
    in: (0..99).to_a,
    message: "Size should be between 5 and 99 liters"
  }, allow_nil: true
end
