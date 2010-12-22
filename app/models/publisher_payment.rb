class PublisherPayment < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :sale
  belongs_to :bank_information
  
  def payment_method
    return "Bank Wire " if bank_information
    return ""
  end
  
  def payment_method_with_data
    return "Bank Wire to #{bank_information.account_number}" if bank_information
    return ""
  end
end
