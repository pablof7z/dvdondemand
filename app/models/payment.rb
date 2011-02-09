class Payment < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  belongs_to :financial_information
  belongs_to :bulk_payment
  has_many :sales, :dependent => :nullify
  
  validates_presence_of :owner_id
  
  def self.totals_for(start,finish)
    sum(:amount, :conditions => { :created_at => start..finish }).round(2)
  end

  def payment_method
    return "Bank Wire " if financial_information.bank?
    return "Paypal " if financial_information.paypal?
    return ""
  end
  
  def payment_method_with_data
    return "Bank Wire to #{financial_information.bank_account_number}" if financial_information.bank?
    return "Paypaled to #{financial_information.paypal_email}" if financial_information.paypal?
    return ""
  end
end
