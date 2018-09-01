class JourneyBag < ApplicationRecord
  belongs_to :journey
  belongs_to :packed_bag
end
