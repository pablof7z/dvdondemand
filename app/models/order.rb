class Order < ActiveRecord::Base
  # Asociations
  belongs_to :sale
  belongs_to :customer
  belongs_to :shipping_option # USPS, FedEx, DHL, etc.
  has_many :customer_payments
  has_many :order_items
  # association for log
  has_many :logs, :as => :loggeable
end
