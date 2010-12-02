class ShippingOption < ActiveRecord::Base
  has_many :orders
  validates_presence_of :title, :price
end
