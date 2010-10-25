module Retail::CartHelper
  def cart_total
    total = 0
    unless customer_session[:cart_items].blank?
      total = customer_session[:cart_items].inject(0) do |total, item|
        total + item['price'].to_f*item['quantity'].to_f
      end
    end
    total
  end

  def cart_item_count
    count = 0
    unless customer_session[:cart_items].blank?
      count = customer_session[:cart_items].inject(0) do |count, item|
        count + item['quantity'].to_i
      end
    end
    count
  end
end

