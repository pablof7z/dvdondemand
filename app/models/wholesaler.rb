class Wholesaler < ActiveRecord::Base
  has_many :orders
  has_many :invoices, :class_name => 'WholesalerInvoice', :order => 'created_at DESC'
  has_many :sales, :through => :invoices
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
  def current_invoice
    # First invoice or last invoice is closed
    if invoices.size == 0 or invoices[0].paid? == false
      new_invoice = WholesalerInvoice.new
      invoices << new_invoice
      new_invoice.save
      return new_invoice
    end
    
    return invoices[0]
  end
  
  def money_owed
    owed = 0
    invoices.each { |invoice| owed = owed + invoice.owed }
    return owed
  end
end
