class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bags, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :journeys, dependent: :destroy

  def packed_bags
    self.bags.map { |bag| bag.packed_bags }.flatten
  end

  def packed_items
    self.packed_bags.map { |packed_bag| packed_bag.packed_items }.flatten
  end
end
