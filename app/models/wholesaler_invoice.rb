class WholesalerInvoice < ActiveRecord::Base
  belongs_to :wholesaler
  has_many :sales
end
