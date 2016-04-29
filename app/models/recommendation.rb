class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommendable, polymorphic: true

  after_update :run_callback

  validates :user, presence: true
  validates :recommendable, presence: true
  validates :action, presence: true, length: { in: 1..500 }
  validates :completed, inclusion: { in: [true, false] }
  validates :query, :field, :kind, :label, :link, length: { maximum: 500 }

  def run_callback
    changes.each do |change|
      property, (old, new) = change
      if property == "completed" && new == true && callback
        recommendable.instance_eval(callback)
      end
    end
  end
end
