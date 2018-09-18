class Bag < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :user
  has_many :packed_bags, dependent: :destroy

  # VALIDATIONS

  validates :name, presence: true
  validates :capacity, presence: true, inclusion: {
    in: (5..120).to_a,
    message: "Size should be between 5 and 120 liters"
  }, allow_nil: true

end
