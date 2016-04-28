class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User
  after_create :send_welcome_email

  has_many :activities
  has_many :companies
  has_many :recommendations
  has_many :leads, through: :companies
  has_many :jobs, through: :companies

  validates :email, uniqueness: true, length: { in: 1..200 }
  validates :password, length: { in: 8..100 }, allow_blank: true

  def score
    activities.sum :points
  end

  def score=(val)
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now!
  end

  handle_asynchronously :send_welcome_email
end
