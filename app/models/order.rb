class Order < ActiveRecord::Base
  belongs_to :sale
  belongs_to :customer
  belongs_to :shipping_option # USPS, FedEx, DHL, etc.
  has_many :customer_payments
  has_many :items, :class_name => 'OrderItem', :dependent => :delete_all

  accepts_nested_attributes_for :items

  validates_presence_of :billing_address

  def item_count
    total = 0
    total = items.inject(0) do |subtotal, item|
      subtotal + item.quantity
    end
    total
  end

  def total
    total = 0
    total = items.inject(0) do |subtotal, item|
      subtotal + item.product.price * item.quantity + item.packaging_option.price
    end
    total
  end
end

