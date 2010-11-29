class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  belongs_to :customer
  actions :new, :create

  def new
    # pre-build order form w/items from the cart
    @order = current_customer.orders.build
    current_customer.cart.items.each do |item|
      @order.items.build(
        :packaging_option_id => item.packaging_option.id,
        :product_id          => item.product.id,
        :quantity            => item.quantity,
        :price               => item.product.price
      )
    end
    new!
  end

  def create
    create! do |success, failure|
      success.html { current_customer.cart.destroy }
      failure.html { render :action => :new }
    end
  end
end

