class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items

  has_many :sales
  has_many :sales_owed, :class_name => 'Sale', :conditions => { :publisher_payment_id => nil }

  has_many :get_stocks, :class_name => 'GetStock'
  has_many :whole_sales, :class_name => 'Wholesale'
  has_many :retail_sales, :class_name => 'Retail'

  has_many :publisher_payments
  has_many :bank_informations
  has_many :validated_bank_informations, :class_name => 'BankInformation', :conditions => { :validated => true }

  named_scope :approved, :conditions => { :approved => true }

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end

  def artist_name
    nickname || full_name
  end

  # all pending payments totals (minus fees)
  def pending_payments
    unless sales.blank?
      sales.inject(0) { |sum,s| sum + (s.total - s.fees) if s.pending_payment }
    else
      0
    end
  end
  
  def default_bank_information
    validated_bank_informations.each do |a|
      return a if a.default
    end
    
    return validated_bank_informations.first
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

