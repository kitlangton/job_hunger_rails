class Job < ActiveRecord::Base
  include Recommendable

  belongs_to :company
  has_one :user, through: :company
  has_many :scores, as: :scoreable

  STATUSES = %w(Interested Applied Rejected Interview Offer).freeze

  validates :title, presence: true, length: { in: 1..200 }
  validates :company_id, presence: true
  validates :url, :notes, length: { maximum: 300 }
  # validates :application_status, inclusion: { in: STATUSES }

  before_create :set_default
  after_create :make_activity

  def recommendable_actions
    [
      {
        field: 'application_status',
        kind: 'action',
        link: url,
        action: 'Submit application',
        callback: "update(application_status: 'Applied')"
      }
    ]
  end

  def field_recommendations
    [
      {
        field: 'application_status',
        kind: 'action',
        link: url,
        action: 'Follow up with application',
        target_value: 'Applied'
      }
    ]
  end

  private

  def set_default
    self.application_status ||= 'Interested'
  end

  def make_activity
    user_id = company.user.id
    points = 202
    description = "User added job #{title} to profile"
    activity = Activity.new(user_id: user_id,
                            points: points,
                            description: description)
    activity.save
  end
end
