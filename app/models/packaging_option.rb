class PackagingOption < ActiveRecord::Base
  has_many :order_items

  has_many :product_options
  has_many :products, :through => :product_options

  validates_presence_of :title, :price

  def title_with_price
    "#{title} (+$#{price})"
  end
end

