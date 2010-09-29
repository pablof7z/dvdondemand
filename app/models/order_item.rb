class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :packaging_option # StandardClamshell, PremiumJewelCase, etc.
  belongs_to :product
end
