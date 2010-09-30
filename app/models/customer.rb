class Customer < ActiveRecord::Base
  has_many :orders
  has_many :product_flags
  has_many :customer_payments
end
