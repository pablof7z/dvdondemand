class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :packaging_option # StandardClamshell, PremiumJewelCase, etc.
  has_one :product
end
