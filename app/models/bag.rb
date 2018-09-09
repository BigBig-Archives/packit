class Bag < ApplicationRecord
  belongs_to :user
  belongs_to :reference, class_name: 'BagRef'
  has_many :packed_bags

  before_create :rename

  def rename
    self.name = self.reference.name if self.name.nil?
  end
end
