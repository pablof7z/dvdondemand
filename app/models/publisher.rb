class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items

  has_many :sales

  has_many :get_orders, :class_name => 'Order'
  has_many :get_stocks, :class_name => 'GetStock'
  has_many :whole_sales, :class_name => 'Wholesale'
  has_many :retail_sales, :class_name => 'Retail'

  has_many :publisher_payments
  has_many :financial_informations
  has_many :validated_financial_informations, :class_name => 'FinancialInformation', :conditions => { :validated => true }

  named_scope :approved, :conditions => { :approved => true }

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
end

