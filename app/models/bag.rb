class Bag < ApplicationRecord
  belongs_to :user
  belongs_to :reference, class_name: 'BagRef'
  has_many :packed_bags, dependent: :destroy

  validates :custom_size, inclusion: { in: (10..99).to_a }

  before_create :rename

  def rename
    self.name = self.reference.name if self.name.nil?
  end
end
