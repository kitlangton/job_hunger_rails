class Company < ActiveRecord::Base
  include Recommendable

  belongs_to :user
  has_many :leads, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :scores, as: :scoreable
  has_many :lead_recommendations, through: :leads, source: :recommendations

  validates :name, presence: true, length: { in: 1..100 }
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :notes, length: { maximum: 500 }
  validates :website, :blog, :address, :glassdoor_website,
            :glassdoor_logo_link, length: { maximum: 300 }

  after_create :make_activity
  after_create :glassdoor_info

  def recommendable_actions
    [
      {
        field: 'blog',
        kind: 'edit',
        query: "#{name} company blog",
        action: 'Add the company blog'
      },
      {
        field: 'website',
        kind: 'edit',
        query: "#{name} company website",
        action: 'Add the website'
      },
      {
        field: 'address',
        kind: 'edit',
        query: "#{name} company address",
        action: 'Add an address'
      },
      {
        field: 'leads',
        label: 'Lead Name',
        kind: 'create',
        action: 'Add a lead'
      }
    ]
  end

  private

  def make_activity
    user_id = user.id
    points = 111
    description = "User added company #{name} to profile"
    activity = Activity.new(
      user_id: user_id,
      points: points,
      description: description
    )
    activity.save
  end

  def glassdoor_info
    # sample call: http://api.glassdoor.com/api/api.htm?t.p=62023&t.k=v2fHKkDtZg&q=test&format=json&v=1&action=employers

    base_string = 'http://api.glassdoor.com/api/api.htm'
    partner_str = 't.p=' + ENV['GLASSDOOR_PARTNER'].to_s
    key_str = 't.k=' + ENV['GLASSDOOR_KEY'].to_s
    query_str = 'q=' + name
    format_str = 'format=json'
    version_str = 'v=1'
    action_str = 'action=employers'

    query_arr = [partner_str, key_str, query_str,
                 format_str, version_str, action_str]

    request_string = base_string + '?' + query_arr.join('&')
    glassdoor_response = HTTParty.get(request_string)
    validate_glassdoor_response(glassdoor_response)
  end

  def validate_glassdoor_response(response)
    unless response.nil? || response['success'] == false ||
           response['response']['employers'].empty?
      self.glassdoor_website = response['response']['employers'][0]['website']
      if website.nil?
        self.website = response['response']['employers'][0]['website']
      end

      self.glassdoor_rating = response['response']['employers'][0]['overallRating'].to_f
      self.glassdoor_logo_link = response['response']['employers'][0]['squareLogo']
    end
    save
  end
end
