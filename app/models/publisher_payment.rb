class PublisherPayment < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :bank_information
  has_many :sales
  
  def payment_method
    return "Bank Wire " if bank_information
    return ""
  end
  
  def payment_method_with_data
    return "Bank Wire to #{bank_information.account_number}" if bank_information
    return ""
  end
end
