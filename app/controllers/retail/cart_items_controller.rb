class Retail::CartItemsController < RetailController
  before_filter :authenticate_customer!
  belongs_to :customer

  def destroy
    destroy! do
      current_customer.cart.destroy if current_customer.cart.items.blank?
      redirect_to retail_customer_cart_url(current_customer) and return
    end
  end
end

