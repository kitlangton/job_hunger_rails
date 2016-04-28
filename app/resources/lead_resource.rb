class LeadResource < JSONAPI::Resource
  has_one :company
  has_many :recommendations

  attributes :name, :linked_in, :blog, :email, :notes
end
