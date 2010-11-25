class Cart < ActiveRecord::Base
  belongs_to :customer
  has_many :items, :class_name => 'CartItem', :dependent => :delete_all
  accepts_nested_attributes_for :items

  def items_total_count
    items.sum(:quantity)
  end

  def items_total_price
    items.sum('price * quantity')
  end
end

