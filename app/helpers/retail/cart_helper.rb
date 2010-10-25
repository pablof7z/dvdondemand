module Retail::CartHelper
  def cart_total
    total = 0
    unless customer_session[:cart_items].blank?
      total = customer_session[:cart_items].inject(0) do |subtotal, item|
        subtotal + item['price'].to_f*item['quantity'].to_f
      end
    end
    total
  end

  def cart_item_count
    count = 0
    unless customer_session[:cart_items].blank?
      count = customer_session[:cart_items].inject(0) do |subtotal, item|
        subtotal + item['quantity'].to_i
      end
    end
    count
  end

  def cart_items_include?(product_id)
    customer_session[:cart_items].each do |item|
      return true if item['product_id'] == product_id.to_s
    end
    false
  end
end

