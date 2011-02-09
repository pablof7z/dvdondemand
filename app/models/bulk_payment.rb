class BulkPayment < ActiveRecord::Base
  has_many :payments, :dependent => :destroy
 
  def initialize
    super
    @ach = ACH.new
  end
  
  def bank_total
    total = 0.0
    payments.map { |t| total = total + t.amount if t.financial_information.payment_method == 'bank' }
    total
  end
  
  def paypal_total
    total = 0.0
    payments.map { |t| total = total + t.amount if t.financial_information.payment_method == 'paypal' }
    total
  end
  
  def total
    total = 0.0
    payments.map { |t| total = total + t.amount }
    total
  end
  
  def avg
    return (payments.size == 0) ? 0 : total / payments.size
  end

  def ach
    (@ach ||= ACH.parse(ach_file))
  end
  
  def add_payment(payment)
    payments << payment
    
    financial_information = payment.financial_information
    
    case financial_information.payment_method
      when 'bank'
        # add ach information
        ach.add_payment(financial_information.bank_account_type,
                        financial_information.bank_routing_number,
                        financial_information.bank_account_number,
                        payment.owner.full_name,
                        payment.amount, id)
      when 'paypal'
        # add paypal information
        self.paypal_file = "" if self.paypal_file == nil
        self.paypal_file << "#{financial_information.paypal_email}\t#{sprintf '%.02f', payment.amount}\t" <<
                            "#{DEFAULT_CURRENCY}\t#{payment.id}\t\n"
    end
  end
  
  def fixate
    ach.generate!
    self.ach_file = ach.dump
  end
end
