class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items

  has_many :sales
  has_many :sales_owed, :class_name => 'Sale', :conditions => { :payment_id => nil }

  has_many :get_stocks, :class_name => 'GetStock'
  has_many :whole_sales, :class_name => 'Wholesale'
  has_many :retail_sales, :class_name => 'Retail'

  has_many :payments, :as => :owner
  has_many :financial_informations, :as => :owner
  has_many :validated_financial_informations, :as => :owner, :class_name => 'FinancialInformation', :conditions => { :validated => true }
  
  belongs_to :affiliate
  belongs_to :affiliate_introduction

  named_scope :approved, :conditions => { :approved => true }
  
  validates_uniqueness_of :affiliate_introduction_id, :allow_nil => true

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end

  def artist_name
    nickname || full_name
  end

  # all pending payments totals (minus fees)
  def pending_payment_totals
    unless sales.pending_payment.blank?
      sales.pending_payment.inject(0) { |sum,s| sum + (s.total - s.fees) }.round(2)
    else
      0
    end
  end
  
  def default_financial_information
    validated_financial_informations.each { |a| return a if a.default }
    return validated_financial_informations.first
  end
  
  def owed
    a = 0.0
    
    sales_owed.each { |sale| a = a + (sale.total - sale.fees) }
    
    a
  end
  
  def owed_fees
    a = 0.0
    
    sales_owed.each do |sale|
      a = a + sale.fees
    end
    
    a
  end
end

