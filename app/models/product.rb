class Product < ActiveRecord::Base
  belongs_to :publisher
  has_many :order_items
  has_and_belongs_to_many :catalogs
  has_and_belongs_to_many :items
  has_many :product_wholesale_prices
  has_many :product_flags
end
