class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  before_filter :no_empty_cart, :only => [:new, :create]
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
      success.html do 
        current_customer.cart.destroy
        # Order was created, but FirstData pay. gw. could fail the purchase
        if @order.purchase
          # order is cashed, so make it a real Retail sale
          @order.to_retail_sale
          render :action => :success
        else
          render :action => :failure
        end
      end
      failure.html { render :action => :new }
    end
  end

  private

  def no_empty_cart
    redirect_to root_url and return if current_customer.cart.blank?
  end
end

