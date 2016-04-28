class UserResource < JSONAPI::Resource
  has_many :companies
  has_many :recommendations
  has_many :jobs
  has_many :leads

  attributes :email, :password, :score, :has_onboarded,
              :default_location, :default_keyword

  filter :email
end
