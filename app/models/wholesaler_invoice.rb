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
    sum = 0
    payments.each {|p| sum = sum + s.amount }
    total.to_i <= sum
  end
end
