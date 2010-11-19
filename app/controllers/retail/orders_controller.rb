class Retail::OrdersController < Retail::RetailController
  before_filter :authenticate_customer!
  belongs_to :customer
  actions :new, :create

  def create
    create! do |success, failure|
      success.html do
        customer_session[:cart_items] = []
        if @order.purchase
          render :action => :success
        else
          render :action => :failure
        end
      end
      failure.html { render :action => :new }
    end
  end
end

