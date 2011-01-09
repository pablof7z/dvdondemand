class Affiliate < ActiveRecord::Base
  has_many :publishers
  has_many :introductions, :class_name => 'AffiliateIntroduction'
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
