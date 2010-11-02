class Retail::CartController < ApplicationController
  before_filter :authenticate_customer!, :find_cart_items
  layout 'retail'

  def index
    @cart_items = customer_session[:cart_items]
  end

  def add_item
    customer_session[:cart_items] << params[:item]
    redirect_to :action => :index
  end

  def del_item
    unless params[:product_id].blank?
      customer_session[:cart_items].delete_if { |item| item['product_id'] == params[:product_id]  }
    end
    redirect_to :action => :index
  end

  def update
    unless customer_session[:cart_items].empty?
      customer_session[:cart_items].map! do |item|
        if item['product_id'] == params[:item][:product_id]
          {'qty' => params[:item][:qty], 'product_id' => item['product_id'], 'catalog_id' => item['catalog_id'], 'price' => item['price']}
        else
          item
        end
      end
    end
    redirect_to :action => :index
  end

  private

  def find_cart_items
    customer_session[:cart_items] ||= []
  end
end

