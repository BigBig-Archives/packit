class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bags, dependent: :destroy
  has_many :packed_bags, through: :bags
  has_many :items, dependent: :destroy
  has_many :packed_items, through: :items
  has_many :journeys, dependent: :destroy

end
