class ShippingOption < ActiveRecord::Base
  has_many :orders
end
