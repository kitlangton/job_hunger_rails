class JobResource < JSONAPI::Resource
  has_one :company
  has_many :recommendations

  attributes :title, :application_status, :url, :company_id
end
