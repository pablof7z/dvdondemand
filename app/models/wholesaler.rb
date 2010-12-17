class Wholesaler < ActiveRecord::Base
  has_many :orders
  has_many :invoices, :class_name => 'WholesalerInvoices'
  has_many :sales, :through => :invoices
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
