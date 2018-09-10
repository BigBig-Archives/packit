class Journey < ApplicationRecord
  belongs_to :user
  has_many :packed_bags, dependent: :destroy

  validates :name, presence: { message: "Name can't be blank" }
  validates :start_date, :end_date, presence: true
  validate :end_after_start

  def end_after_start
    return if self.end_date >= self.start_date
    if self.end_date < self.start_date
      errors.add(:end_date, "End date can't append before start date")
    end
  end
end
