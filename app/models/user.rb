class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bags, dependent: :destroy
  has_many :packed_bags, through: :bags
  has_many :items, dependent: :destroy
  has_many :references, through: :items
  has_many :packed_items, through: :items
  has_many :journeys, dependent: :destroy

  # METHODS

  def reference_count(reference_to_count)
    self.references.select { |reference| reference == reference_to_count }.count
  end
end
