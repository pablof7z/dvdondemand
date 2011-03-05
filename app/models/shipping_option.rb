class ShippingOption < ActiveRecord::Base
  has_many :orders
  default_scope :order => 'price'
  validates_presence_of :title, :price

  # set the pagination limit here, but mind the tests
  def self.per_page
    10
  end

  def self.per_disc_cost
    0.6
  end

  def title_with_price
    "#{title} (+$#{price})"
  end
end
