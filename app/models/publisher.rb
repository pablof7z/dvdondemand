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
  has_many :financial_informations
  has_many :validated_financial_informations, :class_name => 'FinancialInformation', :conditions => { :validated => true }

  named_scope :approved, :conditions => { :approved => true }

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable
  
  define_index do
    indexes first_name
    indexes last_name
    indexes email
    
    indexes catalogs.title
    indexes catalogs.description
    
    indexes products.genre.title
    indexes products.title
    indexes products.studio
    indexes products.performers
    indexes products.description
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def artist_name
    nickname || full_name
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

