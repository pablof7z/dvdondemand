class Affiliate < ActiveRecord::Base
  has_many :publishers
  has_many :affiliate_introductions
  has_many :payments, :as => :owner
  
  has_many :financial_informations
  has_many :validated_financial_informations, :class_name => 'FinancialInformation', :conditions => { :validated => true }
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
  def default_financial_information
    validated_financial_informations.each { |a| return a if a.default }
    return validated_financial_informations.first
  end
end
