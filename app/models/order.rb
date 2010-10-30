class Order < ActiveRecord::Base
  belongs_to :sale
  belongs_to :customer
  belongs_to :shipping_option # USPS, FedEx, DHL, etc.
  has_many :customer_payments
  has_many :order_items, :dependent => :delete_all

  accepts_nested_attributes_for :order_items

  validates_presence_of :billing_address
end

