class Retail::OrdersController < Retail::RetailController
  before_filter :authenticate_customer!
  belongs_to :customer
  actions :new, :create

  def create
    create! do |success, failure|
      success.html { customer_session[:cart_items] = [] }
      failure.html { render :action => :new }
    end
  end
end

