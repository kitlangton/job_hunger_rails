class CompanyResource < JSONAPI::Resource
  has_one :user
  has_many :jobs
  has_many :leads
  has_many :recommendations

  attributes :name, :notes, :interest, :website, :blog,
             :address, :glassdoor_rating, :glassdoor_website
end
