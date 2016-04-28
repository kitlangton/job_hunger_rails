class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :scoreable, polymorphic: true

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :points, presence: true, numericality: { only_integer: true }
  validates :description, length: { maximum: 500 }
end
