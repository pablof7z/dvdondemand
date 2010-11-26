class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  belongs_to :customer
  actions :new, :create

  def create
    create! do |success, failure|
      success.html { current_customer.cart.destroy }
      failure.html { render :action => :new }
    end
  end
end

