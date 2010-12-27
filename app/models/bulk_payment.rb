class BulkPayment < ActiveRecord::Base
  has_many :publisher_payments, :dependent => :destroy
  
  def self.new
    super
    
    # ach code
  end
  
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
  
  def add_publisher_payment(publisher_payment)
    publisher_payments << publisher_payment
    
    financial_information = publisher_payment.financial_information
    
    case financial_information.payment_method
      when 'bank'
        # available
        # financial_information.bank_name
        # financial_information.bank_account_number
        # financial_information.bank_routing_number
        # financial_information.bank_account_type
      when 'paypal'
        # add paypal information
        self.paypal_file = "" if self.paypal_file == nil
        self.paypal_file << "#{financial_information.paypal_email}\t#{sprintf '%.02f', publisher_payment.amount}\t" <<
                            "#{DEFAULT_CURRENCY}\t#{publisher_payment.id}\t\n"
    end
  end
  
  def fixate
  end
end
