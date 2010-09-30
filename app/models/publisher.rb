class Publisher < ActiveRecord::Base
  has_many :catalogs
  has_many :products
  has_many :items
  has_many :sales
  has_many :publisher_payments
  has_many :validation_data
end
