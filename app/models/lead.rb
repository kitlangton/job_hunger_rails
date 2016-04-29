class Lead < ActiveRecord::Base
  include Recommendable

  belongs_to :company

  has_many :scores, as: :scoreable
  has_one :user, through: :company

  validates :company_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true, length: { in: 1..300 }
  validates :linked_in, :blog, :notes, :email, length: { maximum: 500 }

  after_create :make_activity

  def recommendable_actions
    [
      {
        field: 'blog',
        kind: 'edit',
        query: "#{name} blog",
        action: 'Add the personal blog'
      },
      {
        field: 'linked_in',
        kind: 'edit',
        query: "#{name} linked in",
        action: 'Add the Linked In account'
      }
    ]
  end

  def field_recommendations
    [
      {
        field: 'blog',
        kind: 'action',
        link: blog,
        action: 'Leave a blog comment'
      }
    ]
  end

  private

  def make_activity
    user_id = company.user.id
    points = 321
    description = "User added lead #{name} to profile"
    activity = Activity.new(user_id: user_id,
                            points: points,
                            description: description)
    activity.save
  end
end
