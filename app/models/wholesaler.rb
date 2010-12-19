class Wholesaler < ActiveRecord::Base
  has_many :orders
  has_many :invoices, :class_name => 'WholesalerInvoice', :order => 'created_at DESC'
  has_many :sales, :through => :invoices
  has_many :payments, :through => :invoices
  
  devise :registerable, :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
  validates_presence_of :api_key
  
  def current_invoice
    # First invoice or last invoice is closed
    if invoices.size == 0 or invoices[0].paid? == true
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
  
  def remaining_credit
    WHOLESALER_CREDIT_LIMIT - money_owed
  end
  
  def before_validation_on_create
    a = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a + %w(@ - _ =)
    
    while true
      s = ""
      64.times { s << a[rand(a.size-1)] }
      break if Wholesaler.find_by_api_key(s) == nil
    end
    self.api_key = s
  end
end
