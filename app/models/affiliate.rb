class Affiliate < ActiveRecord::Base
  has_many :publishers, :dependent => :nullify
  has_many :affiliate_introductions, :dependent => :destroy
  has_many :payments, :as => :owner
  
  has_many :financial_informations, :as => :owner, :dependent => :destroy
  has_many :validated_financial_informations, :as => :owner, :class_name => 'FinancialInformation', :conditions => { :validated => true }
  
  named_scope :approved, :conditions => { :approved => true }
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  def full_name
    "#{name}"
  end
  
  def default_financial_information
    validated_financial_informations.each { |a| return a if a.default }
    return validated_financial_informations.first
  end
  
  def sales_owed
    a = []
    publishers.each { |p| p.sales_owed_to_affiliate.each { |s| a << s } }
    a
  end
  
  def owed
    s = 0.0
    
    publishers.each { |p| s = s + owed_for_publisher(p) }
    
    s
  end
  
  def paid_for_publisher(publisher)
    s = 0.0
    
    publisher.sales_paid_to_affiliate.each do |sale|
      s = s + (((sale.total - sale.fees) * commission_percentage)/100)
      s = s + sale.quantity * commission_per_unit
    end
    
    s
  end
  
  def owed_for_publisher(publisher)
    s = 0.0
    
    publisher.sales_owed_to_affiliate.each do |sale|
      s = s + (((sale.total - sale.fees) * commission_percentage)/100)
      s = s + sale.quantity * commission_per_unit
    end
    
    s
  end
end
