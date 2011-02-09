class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :packaging_option
end

