class Retail::CartController < ApplicationController
  before_filter :authenticate_customer!, :find_cart_items
  layout 'retail'

  def index
    @cart_total = customer_session[:cart_items].inject(0) do |total, product_id|
      product = Product.find(product_id)
      total + product.price
    end
  end

  def add_item
    customer_session[:cart_items] << params[:product_id]
    redirect_to :action => :index
  end

  private

  def find_cart_items
    customer_session[:cart_items] ||= []
  end
end

