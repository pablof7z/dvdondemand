class ProductOption < ActiveRecord::Base
  belongs_to :product
  belongs_to :packaging_option
end
