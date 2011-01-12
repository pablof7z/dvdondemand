class Affiliate < ActiveRecord::Base
  has_many :publishers, :dependent => :nullify
  has_many :affiliate_introductions, :dependent => :destroy
  has_many :payments, :as => :owner
  has_many :sales, :through => :publishers
  
  has_many :financial_informations, :as => :owner, :dependent => :destroy
  has_many :validated_financial_informations, :as => :owner, :class_name => 'FinancialInformation', :conditions => { :validated => true }
  
  validates_presence_of :name
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
  
  named_scope :approved, :conditions => { :approved => true }
  
  devise :database_authenticatable, :rememberable, :trackable

  def full_name
    "#{name}"
  end
  
  # all pending payments totals (minus fees)
  def pending_payment_totals
    unless sales.pending_payment_affiliate.blank?
      sales.pending_payment_affiliate.inject(0) { |sum, s| sum + commission(s) }.round(2)
    else
      0
    end
  end
  
  def default_financial_information
    validated_financial_informations.each { |a| return a if a.default }
    return validated_financial_informations.first
  end
  
  def paid_for_publisher(publisher)
    s = 0.0
    
    publisher.sales.done_payment_affiliate.each { |sale| s = s + commission(sale) }
    
    s
  end
  
  def owed_for_publisher(publisher)
    s = 0.0
    
    publisher.sales.pending_payment_affiliate.each { |sale| s = s + commission(sale) }
    
    s
  end
  
  private
  
  def commission(sale)
    (((sale.total - sale.fees) * commission_percentage)/100) +
      sale.quantity * commission_per_unit
  end
end

