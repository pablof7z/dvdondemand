class Retail::CartController < ApplicationController
  before_filter :authenticate_customer!, :find_cart_items
  layout 'retail'

  def index; end

  def add_item
    customer_session[:cart_items] << params[:item]
    redirect_to :action => :index
  end

  private

  def find_cart_items
    customer_session[:cart_items] ||= []
  end
end

