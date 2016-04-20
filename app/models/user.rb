class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :companies
  has_many :recommendations
  has_many :leads, through: :companies
  has_many :jobs, through: :companies
end
