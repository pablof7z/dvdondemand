class Retail::CartsController < Retail::RetailController
  before_filter :authenticate_customer!
  belongs_to :customer, :singleton => true

  def show
    show! { redirect_to root_url and return if current_customer.cart.blank? }
  end

  def destroy
    destroy! { root_url }
  end
end

