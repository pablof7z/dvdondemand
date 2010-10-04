class Product < ActiveRecord::Base
  belongs_to :publisher
  has_many :order_items
  has_and_belongs_to_many :catalogs
  has_and_belongs_to_many :items
  has_many :wholesale_prices, :dependent => :delete_all
  has_many :product_flags

  accepts_nested_attributes_for :wholesale_prices, :reject_if => lambda { |w| w[:minimum_quantity].blank? || w[:discount_percentage].blank? }
end
