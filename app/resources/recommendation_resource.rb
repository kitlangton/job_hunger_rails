class RecommendationResource < JSONAPI::Resource
  has_one :user
  has_one :recommendable, polymorphic: true

  attributes :user_id, :start_date, :completed, :action,
              :query, :field, :kind, :label, :link
end
