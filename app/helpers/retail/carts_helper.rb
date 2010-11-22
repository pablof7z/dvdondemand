module Retail::CartsHelper
  def cart_total_items
    if current_customer.cart.blank?
      '0'
    else
      current_customer.cart.items.sum(:quantity)
    end
  end
end

