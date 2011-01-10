class Affiliate < ActiveRecord::Base
  has_many :publishers, :dependent => :nullify
  has_many :affiliate_introductions, :dependent => :destroy
  has_many :payments, :as => :owner
  has_many :sales, :through => :publishers
  
  has_many :financial_informations, :as => :owner, :dependent => :destroy
  has_many :validated_financial_informations, :as => :owner, :class_name => 'FinancialInformation', :conditions => { :validated => true }
  
  named_scope :approved, :conditions => { :approved => true }
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  def full_name
    "#{name}"
  end
  
  # all pending payments totals (minus fees)
  def pending_payment_totals
    unless sales.pending_payment_affiliate.blank?
      sales.pending_payment_affiliate.inject(0) do |sum,s|
        sum + (((s.total - s.fees) * commission_percentage)/100) +
              (s.quantity * commission_per_unit)
      end.round(2)
    else
      0
    end
  end
  
  def default_financial_information
    validated_financial_informations.each { |a| return a if a.default }
    return validated_financial_informations.first
  end
  
  def owed_previous
    s = 0.0
    
    publishers.each { |p| s = s + owed_for_publisher(p) }
    
    s
  end
  
  def paid_for_publisher(publisher)
    s = 0.0
    
    publisher.sales.done_payment_affiliate.each do |sale|
      s = s + (((sale.total - sale.fees) * commission_percentage)/100)
      s = s + sale.quantity * commission_per_unit
    end
    
    s
  end
  
  def owed_for_publisher(publisher)
    s = 0.0
    
    publisher.sales.pending_payment_affiliate.each do |sale|
      s = s + (((sale.total - sale.fees) * commission_percentage)/100)
      s = s + sale.quantity * commission_per_unit
    end
    
    s
  end
end
