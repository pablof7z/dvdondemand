class Publisher < ActiveRecord::Base
  has_many :catalogs
  has_many :products
  has_many :items
  has_many :sales
end
