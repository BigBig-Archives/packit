class Journey < ApplicationRecord
  belongs_to :user
  has_many :journey_bags, dependent: :destroy

  validates :name, presence: true
end
