class Bag < ApplicationRecord
  belongs_to :user
  has_many :packed_bags, dependent: :destroy

  validates :name, presence: true
  validates :capacity, presence: true, inclusion: {
    in: (5..99).to_a,
    message: "Size should be between 5 and 99 liters"
  }, allow_nil: true
end
