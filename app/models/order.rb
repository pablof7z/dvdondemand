class Order < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :customer
  belongs_to :shipping_option # USPS, FedEx, DHL, etc.
  has_many :order_items
  has_many :payments
end
