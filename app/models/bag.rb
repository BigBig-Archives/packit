class Bag < ApplicationRecord
  belongs_to :user
  belongs_to :reference, class_name: 'BagRef'
  has_many :packed_bags, dependent: :destroy

  validates :custom_capacity, inclusion: {
    in: (5..99).to_a,
    message: "Size should be between 5 and 99 liters"
  }

  before_create :rename

  def rename
    self.name = self.reference.name if self.name.nil?
  end
end
