class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :packaging_option
  belongs_to :catalog
  belongs_to :product
end
