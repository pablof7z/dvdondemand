class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  belongs_to :customer

  def create
    create! { customer_session[:cart_items] = [] }
  end
end

