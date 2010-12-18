class WholesalerPayment < ActiveRecord::Base
  belongs_to :invoice, :class_name => 'WholesalerInvoice'
  
  validates_presence_of :amount
end
