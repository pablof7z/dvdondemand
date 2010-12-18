class WholesalerInvoice < ActiveRecord::Base
  belongs_to :wholesaler
  has_many :sales
  has_many :payments, :class_name => 'WholesalerPayment'
  has_many :orders, :through => :sales
  
  def total
    sum = 0
    sales.each {|s| sum = sum + s.total }
    sum
  end
  
  def paid?
    owed <= 0
  end
  
  def at_least_partially_paid?
    payments.size != 0
  end
  
  def owed
    sum = 0
    payments.each {|p| sum = sum + p.amount }
    total.to_f - sum
  end
end

