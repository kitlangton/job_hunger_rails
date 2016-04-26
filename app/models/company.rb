class Company < ActiveRecord::Base
  include Recommendable

  belongs_to :user
  has_many :leads, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :scores, as: :scoreable

  validates :name, presence: true, length: { minimum: 1 }
  validates :user_id, presence: true

  after_create :make_activity
  after_create :get_glassdoor_info

  # Recommendable

  def recommendable_actions
    [
      {
        field: 'blog',
        query: "#{name} company blog",
        action: 'Add the company blog'
      },
      {
        field: 'website',
        query: "#{name} company website",
        action: 'Add the website'
      },
      {
        field: 'address',
        query: "#{name} company address",
        action: 'Add an address'
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



  def get_glassdoor_info
    base_string = "http://api.glassdoor.com/api/api.htm"

    partner_str = "t.p=" + ENV['GLASSDOOR_PARTNER'].to_s
    key_str =  "t.k=" + ENV['GLASSDOOR_KEY'].to_s
    query_str = "q="+ name
    format_str = "format=json"
    version_str = "v=1"
    action_str = "action=employers"

    query_arr = [
      partner_str,
      key_str,
      query_str,
      format_str,
      version_str,
      action_str
    ]

    request_string = base_string + "?" + query_arr.join("&")
    # puts request_string
    glassdoor_response = HTTParty.get( request_string )
    # pp glassdoor_response
    # pp glassdoor_response['response']
    validate_glassdoor_response glassdoor_response
    self.save
  end

  def validate_glassdoor_response( response ) 
    puts "validation function"
    # pp response
    if response
      # puts "first if"
      if response['response'] 
        if response['response']['employers']
          # puts "second if"
          if response['response']['employers'][0]
          # puts "third if"
        
            if response['response']['employers'][0]['website']
              self.glassdoor_website = response['response']['employers'][0]['website']
              # puts self.glassdoor_website
            end

            if response['response']['employers'][0]['overallRating']
              self.glassdoor_rating = response['response']['employers'][0]['overallRating'].to_f
              # puts self.glassdoor_rating
            end

            if response['response']['employers'][0]['squareLogo']
              self.glassdoor_logo_link = response['response']['employers'][0]['squareLogo']
              # puts self.glassdoor_logo_link 
            end
          end
        end
      end
    end
  end

end
