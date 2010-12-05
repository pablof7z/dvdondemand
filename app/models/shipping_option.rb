class ShippingOption < ActiveRecord::Base
  has_many :orders
  default_scope :order => 'price'
  validates_presence_of :title, :price

  def title_with_price
    "#{title} (+$#{price})"
  end
end
