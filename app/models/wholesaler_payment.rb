class WholesalerPayment < ActiveRecord::Base
  belongs_to :invoice, :class_name => 'WholesalerInvoice'
end
