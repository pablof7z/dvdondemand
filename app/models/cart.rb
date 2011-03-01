class Cart < ActiveRecord::Base
  belongs_to :customer
  has_many :items, :class_name => 'CartItem', :dependent => :delete_all
  accepts_nested_attributes_for :items

  def items_total_count
    items.sum(:quantity)
  end

  def items_total_price
    items.inject(0) { |sum,i| sum + i.price*i.quantity + i.packaging_option.price*i.quantity }
  end

  def items_include?(product)
    items.reject { |i| i.product != product } != []
  end

  def assign_customer(customer)
    customer.cart = self
    customer.save!

    write_attribute(:customer_id, customer.id)
    items.each do |item|
      item.customer_id = customer.id
      item.save!
    end
    self.save!
  end
end
