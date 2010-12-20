class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items

  has_many :sales
  has_many :whole_sales, :class_name => 'Wholesale'
  has_many :retail_sales, :class_name => 'Retail'

  has_many :publisher_payments
  has_many :bank_informations

  named_scope :approved, :conditions => { :approved => true }

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end

  def artist_name
    nickname || full_name
  end
  
  def default_bank_information
    bank_informations.each do |a|
      return a if a.default
    end
    
    return nil
  end
end

