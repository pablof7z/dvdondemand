module Retail::CartsHelper
  def items_total_count
    if current_customer.cart.blank?
      '0'
    else
      current_customer.cart.items_total_count
    end
  end
end

