class FinancialInformation < ActiveRecord::Base
  belongs_to :deposit1, :class_name => 'PublisherPayment'
  belongs_to :deposit2, :class_name => 'PublisherPayment'
  belongs_to :publisher
  has_many :publisher_payment
  
  validates_inclusion_of :payment_method, :in => %w(bank paypal), :message => 'payment method must be bank | paypal'
  
  validates_presence_of :bank_account_number, :bank_routing_number, :bank_name, :if => :bank?
  validates_inclusion_of :bank_account_type, :in => %w(Checking Savings), :message => 'account type must be checking or savings account', :if => :bank?
  validates_uniqueness_of :bank_account_number, :scope => [ :bank_routing_number, :publisher_id ], :if => :bank?
  
  validates_format_of :paypal_email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, :message => 'must be valid',  :if => :paypal?
  validates_uniqueness_of :paypal_email, :scope => :publisher_id, :if => :paypal?
  
  named_scope :waiting_approval, :conditions => [ "validated IS NULL AND deposit1_id IS NOT NULL AND deposit2_id IS NOT NULL" ]
  
  NotValidated = "Not validated"
  Validated = "Validated"
  DepositSent = "Awaiting validation"
  
  def bank?
    payment_method == "bank"
  end
  
  def paypal?
    payment_method == "paypal"
  end
  
  def account_name
    if bank?
      return bank_name
    elsif paypal?
      return "Paypal"
    end
  end
  
  def account_number()
    if bank?
      return bank_account_number
    elsif paypal?
      return paypal_email
    end
  end
  
  def validation_status
    return Validated if validated
    return DepositSent if ! validated and deposit1 != nil and deposit2 != nil
    return NotValidated
  end
  
  def send_deposit
    if validation_status != NotValidated
      self.errors.add_to_base("Deposit already sent")
      return false
    end
    
    self.deposit1 = PublisherPayment.new(:publisher => publisher, :financial_information => self, :amount => random_deposit, :memo => "Account validation deposit")
    self.deposit2 = PublisherPayment.new(:publisher => publisher, :financial_information => self, :amount => random_deposit, :memo => "Account validation deposit")
    self.deposit1.save!
    self.deposit2.save!
    self.save!
  end
  
  def validate_deposits(deposit1, deposit2)
    deposit1.gsub!(/$/, '')
    deposit2.gsub!(/$/, '')
    
    raise if self.deposit1.amount == deposit1.to_f and self.deposit2.amount == deposit2.to_f
    raise if self.deposit1.amount == deposit2.to_f and self.deposit2.amount == deposit1.to_f
    
    return false
    
  rescue
    self.validated = true
    self.default = true if publisher.default_financial_information == nil
    self.publisher.approved = true
    self.publisher.approval_source = "Approved through amount confirmation on #{DateTime.now}"
    
    self.save! and self.publisher.save!
  end
  
  private
  
  def random_deposit
    sprintf("%.02f", (rand(30)/100.0)+0.01)
  end
end
