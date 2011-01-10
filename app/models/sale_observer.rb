class SaleObserver < ActiveRecord::Observer
  def after_create(sale)
    sale.order.items.map do |item|
      item.product.publisher == sale.publisher ? item : nil
    end.compact.each do |item|
      product = item.product
      product.times_sold += item.quantity
      product.save
    end
  end
end
