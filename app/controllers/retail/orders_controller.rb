class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  belongs_to :customer
  actions :new, :create

  def new
    # pre-build order w/items in the cart
    @order = current_customer.orders.build
    current_customer.cart.items.each { |item| @order.items.build(:product_id => item.product.id, :packaging_option_id => item.packaging_option.id, :price => item.product.price, :quantity => item.quantity) }
    new!
  end

  def create
    create! do |success, failure|
      success.html { current_customer.cart.destroy }
      failure.html { render :action => :new }
    end
  end
end

