class BankInformation < ActiveRecord::Base
  belongs_to :deposit1, :class_name => 'PublisherPayment'
  belongs_to :deposit2, :class_name => 'PublisherPayment'
  belongs_to :publisher
  
  validates_presence_of :account_number, :routing_number, :bank_name
  validates_inclusion_of :account_type, :in => %w(Checking Savings), :message => 'account type must be checking or savings account'
  
  NotValidated = "Not validated"
  Validated = "Validated"
  DepositSent = "Awaiting validation"
  
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
    
    self.deposit1 = PublisherPayment.new(:publisher => publisher, :bank_information => self, :amount => random_deposit)
    self.deposit2 = PublisherPayment.new(:publisher => publisher, :bank_information => self, :amount => random_deposit)
    self.deposit1.save
    self.deposit2.save
    self.save
  end
  
  def validate_deposits(deposit1, deposit2)
    deposit1.gsub!(/$/, '')
    deposit2.gsub!(/$/, '')
    
    raise if self.deposit1.amount == deposit1.to_f and self.deposit2.amount == deposit2.to_f
    raise if self.deposit1.amount == deposit2.to_f and self.deposit2.amount == deposit1.to_f
    
    return false
    
  rescue
    self.validated = true
    self.default = true if publisher.default_bank_information == nil
    self.publisher.approved = true
    self.publisher.approval_source = "Approved through bank confirmation on #{DateTime.now}"
    
    self.save! and self.publisher.save!
  end
  
  private
  
  def random_deposit
    sprintf("%.02f", (rand+0.10)%1)
  end
end
