class Order < ActiveRecord::Base
  has_one :payment
  belongs_to :customer
  has_one :shipment
  has_many :order_items
end
