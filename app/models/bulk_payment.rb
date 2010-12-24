class BulkPayment < ActiveRecord::Base
  has_many :publisher_payments, :dependent => :destroy
  
  def bank_total
    total = 0.0
    publisher_payments.map { |t| total = total + t.amount if t.financial_information.payment_method == 'bank' }
    total
  end
  
  def paypal_total
    total = 0.0
    publisher_payments.map { |t| total = total + t.amount if t.financial_information.payment_method == 'paypal' }
    total
  end
  
  def total
    total = 0.0
    publisher_payments.map { |t| total = total + t.amount }
    total
  end
  
  def avg
    return (publisher_payments.size == 0) ? 0 : total / publisher_payments.size
  end
  
  def generate
  end
end
