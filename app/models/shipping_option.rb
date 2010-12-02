class ShippingOption < ActiveRecord::Base
  has_many :orders
  validates_presence_of :title, :price

  def title_with_price
    "#{title} (+$#{price})"
  end
end
